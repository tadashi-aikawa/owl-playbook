import { defineConfig, devices } from "@playwright/test";

/**
 * See https://playwright.dev/docs/test-configuration.
 */
export default defineConfig({
  testDir: "./tests",
  reporter: "html",

  // 全体でシーケンシャル(更新系があるため)
  fullyParallel: false,
  // ファイル内もシーケンシャル(更新系があるため)
  workers: 1,
  // リトライはしない(データに冪等性がなければテストできないから)
  retries: 0,
  // test.onlyやdescribe.onlyが残っていたときCIでエラーを吐く(消し忘れ防止)
  forbidOnly: !!process.env.CI,

  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"], channel: "chromium" },
    },
  ],
});
