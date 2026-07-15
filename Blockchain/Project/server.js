/**
 * RWA 前端服务器 + RPC 代理
 * 提供静态文件服务 + 将 /rpc 请求转发到 Hardhat 节点
 * 解决浏览器在容器外无法直连 127.0.0.1:8545 的问题
 */
const http = require("http");
const fs = require("fs");
const path = require("path");

const PORT = 8080;
const HARDHAT_RPC = "http://127.0.0.1:8545";
const FRONTEND_DIR = path.join(__dirname, "frontend");

const MIME = {
    ".html": "text/html; charset=utf-8",
    ".js": "application/javascript; charset=utf-8",
    ".css": "text/css; charset=utf-8",
    ".png": "image/png",
    ".jpg": "image/jpeg",
    ".svg": "image/svg+xml",
    ".ico": "image/x-icon",
    ".json": "application/json; charset=utf-8",
};

const server = http.createServer((req, res) => {
    // CORS 头
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    res.setHeader("Access-Control-Allow-Headers", "Content-Type");
    // 禁用缓存（开发阶段）
    res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    res.setHeader("Pragma", "no-cache");

    // RPC 代理：/rpc → Hardhat 8545
    if (req.url.startsWith("/rpc")) {
        // CORS 预检直接返回
        if (req.method === "OPTIONS") {
            res.writeHead(204, {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type",
            });
            res.end();
            return;
        }
        let body = "";
        req.on("data", chunk => body += chunk);
        req.on("end", () => {
            const proxyReq = http.request(HARDHAT_RPC, {
                method: req.method,
                headers: { "Content-Type": "application/json" },
            }, proxyRes => {
                res.writeHead(proxyRes.statusCode, { "Content-Type": "application/json" });
                proxyRes.pipe(res);
            });
            proxyReq.on("error", () => {
                res.writeHead(502, { "Content-Type": "application/json" });
                res.end(JSON.stringify({ error: "Hardhat node unreachable" }));
            });
            if (body) proxyReq.write(body);
            proxyReq.end();
        });
        return;
    }

    // 静态文件服务
    let urlPath = req.url === "/" ? "/index.html" : req.url;
    // 去除查询参数
    urlPath = urlPath.split("?")[0];
    const filePath = path.join(FRONTEND_DIR, urlPath);

    // 安全检查：防止路径穿越
    if (!filePath.startsWith(FRONTEND_DIR)) {
        res.writeHead(403);
        res.end("Forbidden");
        return;
    }

    fs.readFile(filePath, (err, data) => {
        if (err) {
            res.writeHead(404, { "Content-Type": "text/plain" });
            res.end("Not Found: " + urlPath);
            return;
        }
        const ext = path.extname(filePath).toLowerCase();
        res.writeHead(200, { "Content-Type": MIME[ext] || "application/octet-stream" });
        res.end(data);
    });
});

server.listen(PORT, "0.0.0.0", () => {
    console.log(`RWA 前端服务启动: http://0.0.0.0:${PORT}`);
    console.log(`RPC 代理: /rpc → ${HARDHAT_RPC}`);
});
