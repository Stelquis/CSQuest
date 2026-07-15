// 同步 deployed-addresses.json 到 frontend/app.js
const fs = require("fs");
const path = require("path");

const addrFile = path.join(__dirname, "deployed-addresses.json");
const appJs = path.join(__dirname, "..", "frontend", "app.js");

if (!fs.existsSync(addrFile)) {
    console.log("skip: no deployed-addresses.json");
    process.exit(0);
}

const addr = JSON.parse(fs.readFileSync(addrFile, "utf8"));
let content = fs.readFileSync(appJs, "utf8");
let changed = 0;

for (const [key, val] of Object.entries(addr)) {
    // 匹配: key: "0x..." 任意大小写
    const re = new RegExp(`${key}:\\s*"0x[0-9a-fA-F]+"`, "g");
    const replacement = `${key}: "${val}"`;
    if (re.test(content)) {
        content = content.replace(re, replacement);
        changed++;
    }
}

if (changed > 0) {
    fs.writeFileSync(appJs, content);
    console.log(`synced ${changed} addresses to app.js`);
} else {
    console.log("addresses already up to date");
}
