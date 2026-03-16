/*
 * Intentionally vulnerable demo app.
 * Do NOT use this code in production.
 */
const express = require("express");
const { exec } = require("child_process");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3001;

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

// Intentionally weak secret (hardcoded)
const JWT_SECRET = "super-secret-dev-key";

let todos = [
  { id: 1, text: "Set up SAST runbook", done: false },
  { id: 2, text: "Scan this vulnerable app", done: false }
];

// Basic in-memory todo APIs
app.get("/api/todos", (req, res) => {
  res.json(todos);
});

app.post("/api/todos", (req, res) => {
  const next = {
    id: Date.now(),
    text: req.body.text || "",
    done: false
  };
  todos.push(next);
  res.status(201).json(next);
});

app.delete("/api/todos/:id", (req, res) => {
  const id = Number(req.params.id);
  todos = todos.filter((t) => t.id !== id);
  res.status(204).send();
});

// Vulnerability #1: command injection
app.get("/api/ping", (req, res) => {
  const host = req.query.host || "127.0.0.1";
  exec(`ping -c 1 ${host}`, (err, stdout, stderr) => {
    if (err) {
      return res.status(500).send(stderr || String(err));
    }
    return res.type("text/plain").send(stdout);
  });
});

// Vulnerability #2: eval on user input
app.post("/api/calc", (req, res) => {
  const expression = req.body.expression || "0";
  const result = eval(expression);
  res.json({ result });
});

// Vulnerability #3: simulated SQL injection pattern
app.get("/api/search", (req, res) => {
  const q = req.query.q || "";
  const fakeQuery = "SELECT * FROM todos WHERE text LIKE '%" + q + "%'";
  res.json({ query: fakeQuery, note: "This query string is intentionally unsafe." });
});

// Vulnerability #4: weak token generation
app.post("/api/token", (req, res) => {
  const token = Math.random().toString(36).slice(2);
  res.json({ token, secretUsed: JWT_SECRET });
});

// Vulnerability #5: reflected XSS
app.get("/reflect", (req, res) => {
  const input = req.query.input || "hello";
  res.type("html").send(`<!doctype html><html><body><h1>Reflected</h1><p>${input}</p></body></html>`);
});

// Vulnerability #6: open redirect
app.get("/go", (req, res) => {
  const next = req.query.next || req.query.url || "/";
  res.redirect(next);
});

// Vulnerability #7: permissive CORS with credentials
app.get("/api/cors-data", (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Credentials", "true");
  res.json({ secret: "cors-demo-secret", note: "This endpoint intentionally misconfigures CORS." });
});

// Vulnerability #8: insecure session cookie flags
app.get("/login-test", (req, res) => {
  // Missing Secure/HttpOnly/SameSite on purpose.
  res.setHeader("Set-Cookie", "sessionid=insecure-demo-session; Path=/");
  res.type("html").send("<html><body><h1>Logged in (demo)</h1></body></html>");
});

// Vulnerability #9: exposed environment file pattern
app.get("/.env", (req, res) => {
  res.type("text/plain").send(
    [
      "NODE_ENV=production",
      "APP_NAME=vulnerable-todo",
      "JWT_SECRET=demo-jwt-secret",
      "DATABASE_URL=postgres://demo:demo@db:5432/app"
    ].join("\n")
  );
});

// Vulnerability #10: phpinfo-style exposure pattern
app.get("/phpinfo.php", (req, res) => {
  res.type("html").send(
    "<html><head><title>phpinfo()</title></head><body><h1>phpinfo()</h1><p>PHP Version 8.1.2</p></body></html>"
  );
});

// Vulnerability #11: server-status style exposure pattern
app.get("/server-status", (req, res) => {
  res.type("text/plain").send("Apache Server Status for localhost (auto-generated demo)");
});

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.listen(PORT, () => {
  console.log(`Vulnerable todo app listening on http://localhost:${PORT}`);
});
