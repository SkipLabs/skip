import { defineConfig, devices } from '@playwright/test';

/**
 * See https://playwright.dev/docs/test-configuration.
 */
export default defineConfig({
  testDir: './',
  testMatch: /.*\.play\.ts/,
  /* Run tests in files in parallel */
  fullyParallel: true,
  /* Fail the build on CI if you accidentally left test.only in the source code. */
  forbidOnly: !!process.env.CI,
  /* Retry on CI only */
  retries: process.env.CI ? 2 : 0,
  /* CI workers have 4 CPUs */
  workers: process.env.CI ? 4 : undefined,
  /* Reporter to use. See https://playwright.dev/docs/test-reporters */
  reporter: 'html',
  /* Shared settings for all the projects below. See https://playwright.dev/docs/api/class-testoptions. */
  use: {
    /* Base URL to use in actions like `await page.goto('/')`. */
    baseURL: 'http://127.0.0.1:8100',

    /* Collect trace when retrying the failed test. See https://playwright.dev/docs/trace-viewer */
    trace: 'on-first-retry',
  },

  /* Configure projects for major browsers */
    projects: [
    {
      name: 'client_nodejs',
      testMatch: /node.play.ts/,
    },
    {
      name: 'server_nodejs',
      testMatch: /node.play.server.ts/,
    },
    {
      name: 'mux_nodejs',
      testMatch: /node.play.mux.ts/,
    },
    {
      name: 'client_chromium',
      use: { ...devices['Desktop Chrome'] },
      testMatch: /browser.play.ts/,
    },
    {
      name: 'server_chromium',
      use: { ...devices['Desktop Chrome'] },
      testMatch: /browser.play.server.ts/,
    },
    {
      name: 'mux_chromium',
      use: { ...devices['Desktop Chrome'] },
      testMatch: /browser.play.mux.ts/,
    },
    {
      name: 'client_firefox',
      use: { ...devices['Desktop Firefox'] },
      testMatch: /browser.play.ts/,
    },
    {
      name: 'server_firefox',
      use: { ...devices['Desktop Firefox'] },
      testMatch: /browser.play.server.ts/,
    },
    {
      name: 'mux_firefox',
      use: { ...devices['Desktop Firefox'] },
      testMatch: /browser.play.mux.ts/,
    },

    // {
    //   name: 'webkit',
    //   use: { ...devices['Desktop Safari'] },
    //   testMatch: /browser.play.ts/,
    // },

    /* Test against mobile viewports. */
    // {
    //   name: 'Mobile Chrome',
    //   use: { ...devices['Pixel 5'] },
    // },
    // {
    //   name: 'Mobile Safari',
    //   use: { ...devices['iPhone 12'] },
    // },

    /* Test against branded browsers. */
    // {
    //   name: 'Microsoft Edge',
    //   use: { ...devices['Desktop Edge'], channel: 'msedge' },
    // },
    // {
    //   name: 'Google Chrome',
    //   use: { ..devices['Desktop Chrome'], channel: 'chrome' },
    // },
  ],

  /* Run your local dev server before starting the tests */
  webServer: {
    command: 'npx http-server ./ -p 8100',
    port: 8100,
    reuseExistingServer:true,
  }
});
