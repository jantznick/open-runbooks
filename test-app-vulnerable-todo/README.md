# Vulnerable Todo Test App

This is a deliberately insecure React + Node/Express app used to test SAST tooling and runbooks.

## WARNING
This app intentionally includes insecure patterns and should only be used in a local test environment.

## Run
```bash
cd test-app-vulnerable-todo
npm install
npm start
```

Then open:
- http://localhost:3001

## Intentionally Included Vulnerabilities
- Command injection via `child_process.exec` in `/api/ping`
- Use of `eval` in `/api/calc`
- SQL injection style string concatenation in `/api/search`
- Weak randomness (`Math.random`) in `/api/token`
- Hardcoded secret in `server.js`
- Client-side XSS sink via `dangerouslySetInnerHTML` in `public/index.html`
- Reflected XSS endpoint in `/reflect`
- Open redirect endpoint in `/go`
- Permissive CORS misconfiguration in `/api/cors-data`
- Insecure cookie flags in `/login-test`
- Exposed `.env`-style endpoint in `/.env`
- phpinfo-style exposure endpoint in `/phpinfo.php`
- server-status-style exposure endpoint in `/server-status`
- Fake secrets fixture file for secrets scanner validation in `secrets-fixtures.txt`

## Scan It With Your Runbook
From repo root:

```bash
semgrep scan --config p/security-audit --json --output ./artifacts/security/sast-results.json ./test-app-vulnerable-todo
```

or

```bash
opengrep scan --config p/security-audit --json --output ./artifacts/security/sast-results.json ./test-app-vulnerable-todo
```

## Scan Secrets With TruffleHog
From repo root:

```bash
SECRETS_SCAN_PATH=./test-app-vulnerable-todo ./runbooks/appsec/secrets-trufflehog-basic.sh
```

The file `secrets-fixtures.txt` contains intentionally fake credential-like patterns for validation.
