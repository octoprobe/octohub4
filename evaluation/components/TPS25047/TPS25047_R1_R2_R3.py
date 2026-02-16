#!/usr/bin/env python3
"""Resistor divider calculator for TPS25047.

Converted from the Octave script TPS25047_R1_R2_R3.m.
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Case:
    name: str
    vin: float
    vin_uv: float
    vin_ov: float
    r1_ohm: float


@dataclass(frozen=True)
class Solution:
    r2_ohm: float
    r3_ohm: float


def solve_r2_r3(case: Case, vuvlo_r: float, vov_r: float) -> Solution:
    """Solve the 2x2 system for R2 and R3 using closed-form algebra."""
    a = case.vin_uv - vuvlo_r
    b = case.vin_uv - vuvlo_r
    c = -vov_r
    d = case.vin_ov - vov_r

    b1 = vuvlo_r * case.r1_ohm
    b2 = vov_r * case.r1_ohm

    det = a * d - b * c
    if det == 0:
        raise ValueError("Singular matrix: cannot solve for R2 and R3.")

    r2 = (b1 * d - b * b2) / det
    r3 = (a * b2 - b1 * c) / det

    return Solution(r2_ohm=r2, r3_ohm=r3)


def verify(
    case: Case, sol: Solution, vuvlo_r: float, vov_r: float
) -> tuple[float, float]:
    vin_uv_check = (
        vuvlo_r * (case.r1_ohm + sol.r2_ohm + sol.r3_ohm) / (sol.r2_ohm + sol.r3_ohm)
    )
    vin_ov_check = vov_r * (case.r1_ohm + sol.r2_ohm + sol.r3_ohm) / sol.r3_ohm
    return vin_uv_check, vin_ov_check


def run_case(case: Case) -> None:
    vuvlo_r = 1.2
    vov_r = 1.2

    print("\n\n{}".format(case.name))
    print("\n========================================")
    print("Input Parameters:")
    print("VIN = {:.2f} V".format(case.vin))
    print("VIN_UV = {:.2f} V".format(case.vin_uv))
    print("VIN_OV = {:.2f} V".format(case.vin_ov))
    print("R1 = {:.2f} kOhm".format(case.r1_ohm / 1e3))
    print("VUVLO_R = {:.2f} V".format(vuvlo_r))
    print("VOV_R = {:.2f} V".format(vov_r))

    sol = solve_r2_r3(case, vuvlo_r, vov_r)

    print("\n----------------------------------------")
    print("Solution:")
    print("R2 = {:.2f} Ohm = {:.2f} kOhm".format(sol.r2_ohm, sol.r2_ohm / 1e3))
    print("R3 = {:.2f} Ohm = {:.2f} kOhm".format(sol.r3_ohm, sol.r3_ohm / 1e3))

    if sol.r2_ohm <= 0 or sol.r3_ohm <= 0:
        print("\nWARNING: Negative resistance detected! Not physically realizable.")

    print("\n----------------------------------------")
    print("Verification:")
    vin_uv_check, vin_ov_check = verify(case, sol, vuvlo_r, vov_r)
    print(
        "VIN_UV from equation: {:.4f} V (should be {:.4f} V)".format(
            vin_uv_check, case.vin_uv
        )
    )
    print(
        "VIN_OV from equation: {:.4f} V (should be {:.4f} V)".format(
            vin_ov_check, case.vin_ov
        )
    )

    error_uv = abs(vin_uv_check - case.vin_uv)
    error_ov = abs(vin_ov_check - case.vin_ov)
    print("Error UV: {:.6f} V".format(error_uv))
    print("Error OV: {:.6f} V".format(error_ov))

    if error_uv < 1e-6 and error_ov < 1e-6:
        print("\nSolution verified successfully!")
    else:
        print("\nWARNING: Solution verification failed!")


def main() -> None:
    print("TPS25047 Resistor Divider Calculator")
    print("========================================")

    run_case(
        Case(
            name="12V Reference Design",
            vin=12.0,
            vin_uv=10.8,
            vin_ov=13.2,
            r1_ohm=470e3,
        )
    )
    run_case(
        Case(
            name="5V Octohub4",
            vin=5.0,
            vin_uv=4.6,
            vin_ov=5.4,
            r1_ohm=470e3,
        )
    )


if __name__ == "__main__":
    main()
