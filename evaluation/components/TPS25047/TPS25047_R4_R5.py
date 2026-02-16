#!/usr/bin/env python3
"""Power Good assertion threshold calculator for TPS25947.

Converted from the Octave script TPS25047_R4_R5.m.
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Case:
    name: str
    vin: float
    vpg_th: float
    r5_ohm: float


@dataclass(frozen=True)
class Solution:
    name: str
    r4_ohm: float
    r5_ohm: float


def solve(case: Case, v_pgth_ref: float) -> Solution:
    r4 = case.r5_ohm * (case.vpg_th / v_pgth_ref - 1)
    return Solution(name="calculated", r4_ohm=r4, r5_ohm=case.r5_ohm)


def verify(sol: Solution, v_pgth_ref: float) -> float:
    return v_pgth_ref * (sol.r4_ohm + sol.r5_ohm) / sol.r5_ohm


def run_case(case: Case, choosen_solutions: list[Solution]) -> None:
    v_pgth_ref = 1.2

    print("\n\n{}".format(case.name))
    print("\n========================================")
    print("Input Parameters:")
    print("VIN = {:.2f} V".format(case.vin))
    print("VPG_TH (Power Good Threshold) = {:.2f} V".format(case.vpg_th))
    print("V_PGTH_REF (Internal Reference) = {:.2f} V".format(v_pgth_ref))
    print("R5 (chosen) = {:.2f} kOhm".format(case.r5_ohm / 1e3))

    solutions: list[Solution] = [
        solve(case, v_pgth_ref),
        *choosen_solutions,
    ]

    for sol in solutions:
        print("\n----------------------------------------")
        print(f"Solution {sol.name}:")
        print("R4 = {:.2f} Ohm = {:.2f} kOhm".format(sol.r4_ohm, sol.r4_ohm / 1e3))
        print("R5 = {:.2f} Ohm = {:.2f} kOhm".format(sol.r5_ohm, sol.r5_ohm / 1e3))

        if sol.r4_ohm <= 0:
            print("\nWARNING: Negative resistance detected! Not physically realizable.")
            print(
                "VPG_TH must be greater than V_PGTH_REF ({:.2f} V)".format(v_pgth_ref)
            )

        print("Verification:")
        vpg_th_check = verify(sol, v_pgth_ref)
        print(
            "VPG_TH from equation: {:.4f} V (should be {:.4f} V)".format(
                vpg_th_check, case.vpg_th
            )
        )

        error_pg = abs(vpg_th_check - case.vpg_th)
        print("Error: {:.6f} V".format(error_pg))

        pg_hysteresis_percent = ((case.vin - case.vpg_th) / case.vin) * 100
        print(
            "\nPower Good hysteresis: {:.1f}% below VIN".format(pg_hysteresis_percent)
        )

        if error_pg < 1e-6:
            print("\nSolution verified successfully!")
        else:
            print("\nWARNING: Solution verification failed!")


def main() -> None:
    print("TPS25947 Power Good Threshold Calculator")
    print("Section 9.3.2.4: Setting Power Good Assertion Threshold")
    print("========================================")

    run_case(
        Case(
            name="12V Reference Design",
            vin=12.0,
            vpg_th=11.4,
            r5_ohm=5.6e3,
        ),
        choosen_solutions=[],
    )
    run_case(
        Case(
            name="5V Octohub4",
            vin=5.0,
            vpg_th=4.5,
            r5_ohm=47e3,
        ),
        choosen_solutions=[
            Solution(
                name="choosen",
                r4_ohm=120e3,
                r5_ohm=47e3,
            ),
        ],
    )


if __name__ == "__main__":
    main()
