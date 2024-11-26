import { describe, expect, test } from "@jest/globals";

function sum(x: number, y: number): number {
  return x + y;
}

describe("sum", () => {
  test("1 + 1 = 2", () => {
    expect(sum(1, 1)).toBe(2);
  });
});
