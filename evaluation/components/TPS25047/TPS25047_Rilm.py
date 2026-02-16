#!/usr/bin/env python3
"""Overcurrent threshold calculator for TPS25947.

Converted from the Octave script TPS25047_Rilm.m.
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Case:
    name: str
    vin: float
    ilim_a: float


@dataclass(frozen=True)
class Solution:
    rilm_ohm: float


def solve(case: Case) -> Solution:
    rilm = 3334 / case.ilim_a
    return Solution(rilm_ohm=rilm)


def verify(case: Case, sol: Solution) -> float:
    return 3334 / sol.rilm_ohm


def run_case(case: Case) -> None:
    print("\n\n{}".format(case.name))
    print("\n========================================")
    print("Input Parameters:")
    print("VIN = {:.2f} V".format(case.vin))
    print("ILIM (Desired Current Limit) = {:.2f} A".format(case.ilim_a))

    sol = solve(case)

    print("\n----------------------------------------")
    print("Solution:")
    if sol.rilm_ohm >= 1e3:
        print(
            "RILM = {:.2f} Ohm = {:.2f} kOhm".format(sol.rilm_ohm, sol.rilm_ohm / 1e3)
        )
    else:
        print(
            "RILM = {:.2f} Ohm = {:.2f} mOhm".format(sol.rilm_ohm, sol.rilm_ohm * 1e3)
        )

    if sol.rilm_ohm <= 0:
        print("\nWARNING: Negative resistance detected! Not physically realizable.")

    print("\n----------------------------------------")
    print("Verification:")
    ilim_check = verify(case, sol)
    print(
        "ILIM from equation: {:.4f} A (should be {:.4f} A)".format(
            ilim_check, case.ilim_a
        )
    )

    error_ilim = abs(ilim_check - case.ilim_a)
    print("Error: {:.6f} A = {:.2f} mA".format(error_ilim, error_ilim * 1e3))

    p_limit = case.vin * case.ilim_a
    print("\nPower at current limit: {:.2f} W".format(p_limit))

    if error_ilim < 1e-6:
        print("\nSolution verified successfully!")
    else:
        print("\nWARNING: Solution verification failed!")


def main() -> None:
    print("TPS25947 Overcurrent Threshold Calculator")
    print("Section 9.3.2.5: Setting Overcurrent Threshold (ILIM)")
    print("========================================")

    run_case(
        Case(
            name="12V Reference Design",
            vin=12.0,
            ilim_a=6.0,
        )
    )
    run_case(
        Case(
            name="5V Octohub4",
            vin=5.0,
            ilim_a=4.9,
        )
    )


if __name__ == "__main__":
    main()
