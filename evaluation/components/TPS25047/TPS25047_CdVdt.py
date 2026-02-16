#!/usr/bin/env python3
"""Output voltage rise time calculator for TPS25947.

Converted from the Octave script TPS25047_CdVdt.m.
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Case:
    name: str
    vin: float
    tr_s: float
    cout_f: float


@dataclass(frozen=True)
class Solution:
    name: str
    sr_v_per_s: float
    cdvdt_nf: float
    iinrush_a: float


def solve(case: Case) -> Solution:
    sr = case.vin / case.tr_s
    cdvdt_nf = 2000 / sr
    iinrush_a = sr / (case.cout_f * 1e6)
    return Solution(
        name="calculated", sr_v_per_s=sr, cdvdt_nf=cdvdt_nf, iinrush_a=iinrush_a
    )


def verify(case: Case, sol: Solution) -> tuple[float, float]:
    sr_check = 2000 / sol.cdvdt_nf
    tr_check = case.vin / sr_check
    return sr_check, tr_check


def run_case(case: Case, choosen_solutions: list[Solution]) -> None:
    print("\n\n{}".format(case.name))
    print("\n========================================")
    print("Input Parameters:")
    print("VIN = {:.2f} V".format(case.vin))
    print("tR (Desired Rise Time) = {:.2f} ms".format(case.tr_s * 1e3))
    print("Cout (Output Capacitance) = {:.2f} uF".format(case.cout_f * 1e6))

    solutions: list[Solution] = [
        solve(case),
        *choosen_solutions,
    ]

    for sol in solutions:
        print("\n----------------------------------------")
        print(f"Solution {sol.name}:")
        print(
            "SR (Slew Rate) = {:.2f} V/s = {:.2f} V/ms".format(
                sol.sr_v_per_s, sol.sr_v_per_s / 1e3
            )
        )
        print("CdVdt = {:.0f} pF = {:.2f} nF".format(sol.cdvdt_nf * 1e3, sol.cdvdt_nf))
        print("Iinrush = {:.2f} A".format(sol.iinrush_a))

        if sol.cdvdt_nf <= 0:
            print(
                "\nWARNING: Negative capacitance detected! Not physically realizable."
            )

        print("Verification:")
        sr_check, tr_check = verify(case, sol)
        print(
            "SR from equation: {:.2f} V/s (should be {:.2f} V/s)".format(
                sr_check, sol.sr_v_per_s
            )
        )
        print(
            "tR from equation: {:.4f} ms (should be {:.4f} ms)".format(
                tr_check * 1e3, case.tr_s * 1e3
            )
        )

        error_tr = abs(tr_check - case.tr_s)
        print("Error: {:.6f} ms".format(error_tr * 1e3))

        if error_tr < 1e-9:
            print("\nSolution verified successfully!")
        else:
            print("\nWARNING: Solution verification failed!")


def main() -> None:
    print("TPS25947 Output Voltage Rise Time Calculator")
    print("Section 9.3.2.3: Setting Output Voltage Rise Time (tR)")
    print("========================================")

    run_case(
        Case(
            name="12V Reference Design",
            vin=12.0,
            tr_s=20e-3,
            cout_f=100e-6,
        ),
        choosen_solutions=[],
    )
    run_case(
        Case(
            name="5V Octohub4",
            vin=5.0,
            tr_s=250e-3,
            cout_f=1000e-6,
        ),
        choosen_solutions=[
            Solution(
                name="choosen",
                sr_v_per_s=20.0,
                cdvdt_nf=100,
                iinrush_a=0.02,
            )
        ],
    )


if __name__ == "__main__":
    main()
