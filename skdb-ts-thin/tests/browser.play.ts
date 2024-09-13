import { test } from "@playwright/test";
import { tests, createSkdb, UnitTest, LOCAL_SERVER } from "./tests";

test.beforeEach(async ({ page }) => {
  await page.goto("/");
  page.on("console", (msg) => {
    if (msg.type() === "error") {
      console.error(msg.text());
    } else {
      console.log(msg.text());
    }
  });
});

function run(t: UnitTest) {
  test(t.name, async ({ page }) => {
    let dbinfo = await createSkdb();
    await page.evaluate(`window.dbinfo = ${JSON.stringify(dbinfo)};`);
    await page.evaluate(`window.LOCAL_SERVER = "${LOCAL_SERVER}";`);    
    await page.evaluate(`window.test = ${t.fun};`);
    let res = await page.evaluate(async () => {
      // @ts-ignore
      let m = await import("./src/index.js");
      window.connect = m.connect;
      window.creds = async (dbinfo: DbInfo): Promise<Creds> => {
        const keyBytes = Uint8Array.from(atob(dbinfo.privateKey), c => c.charCodeAt(0));
        const key = await crypto.subtle.importKey(
          "raw",
          keyBytes,
          { name: "HMAC", hash: "SHA-256" },
          false,
          ["sign"],
        );
        return {
          accessKey: dbinfo.accessKey,
          privateKey: key,
          deviceUuid: crypto.randomUUID(),
        }
      };

      // @ts-ignore
      return await window.test(window.dbinfo);
    });
    t.check(res);
  });
}

tests().forEach(run);
