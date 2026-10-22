# 🖥️ Desktop, Mobile, and Local IPC Threat Catalog

> **Standard:** FRIDAY-PROTOCOL v2.2.0 (Cognitive DevSecOps)  
> **Target Surface:** Electron Applications (Sovereign InfraMap, Friday HUD), Tauri/Native Desktop Apps, Mobile Apps, Local Daemons, Named Pipes, Unix Sockets, Webview Bridges, and Deep-Link Handlers.  
> **Core Invariant:** *Local IPC channels and webview bridges are untrusted communication boundaries requiring strict peer authentication and payload validation.*

---

## 🏛️ Core Hunting Discipline

1. **Establish the Untrusted Actor:** In desktop/mobile architectures, threats originate from malicious websites opened in webviews, other local applications on the operating system, lower-privilege users, or deep-link navigation triggers.
2. **Paths and Bundle IDs are NOT Authentication:** Claimed process names, bundle IDs, or caller-reported sender strings can be spoofed. Rely on OS peer credentials, code signing verification, or isolated context bridges.
3. **Webview Bridge Authorization:** The native bridge or preload script must authorize every requested action and validate normalized arguments. A pretty UI does not make IPC parameters safe.
4. **Context Isolation & Node Integration:** In Electron applications, `contextIsolation` must always be `true` and `nodeIntegration` must always be `false`.

---

## 🔍 Attack Classes & Hunting Vectors

### 1. Webview and Context-Bridge Attacks
- **Over-Broad Native Bridge Capabilities:**
  - *Vector:* Preload script exposes powerful, unconstrained methods via `contextBridge.exposeInMainWorld` (e.g. `executeCommand`, `readFile`, `shell.openExternal`, `fs.writeFile`).
  - *Audit Check:* Enforce granular, allowlisted methods with validated, typed parameters. Never pass raw shell command strings or arbitrary filesystem paths from renderer to main process.
- **Navigation-Origin to Bridge Confusion:**
  - *Vector:* An Electron window or webview intended for local packaged assets navigates to an external URL or is redirected via XSS, allowing remote web content to access privileged native APIs.
  - *Audit Check:* Verify `will-navigate` and `new-window` event handlers restrict navigation strictly to local `file://` or trusted origin allowlists.
- **Webview Universal File Access Overreach:**
  - *Vector:* Webview settings enable `allowRunningInsecureContent`, `webSecurity: false`, or file access flags that permit web origins to read local disk files.
  - *Audit Check:* Ensure `webSecurity: true`, `nodeIntegration: false`, `contextIsolation: true`, and `sandbox: true` are pinned in `webPreferences`.

### 2. Deep-Links, Callbacks, and Protocol Handlers
- **Custom URL Scheme Hijacking & Ambiguity:**
  - *Vector:* An app registers a custom protocol (e.g. `myapp://`) and executes state-mutating actions (login, data import, token extraction) based on incoming URLs without validating user intent or one-time nonce tokens.
  - *Audit Check:* Validate that custom protocol handlers normalize URIs, verify active user intent, reject dangerous CLI arguments, and require confirmation for mutating actions.
- **App & Account Handoff Confusion:**
  - *Vector:* OAuth, SSO, or magic-link browser callbacks return authentication tokens to the desktop app without state binding, allowing an attacker to link their account to the victim's local session.
  - *Audit Check:* Bind OAuth callbacks using PKCE (`code_challenge` / `code_verifier`) and cryptographically random session states.

### 3. Local IPC, Named Pipes, and Daemons
- **IPC Peer Authentication Gaps:**
  - *Vector:* A local daemon, background service, or local HTTP server listens on a localhost port, Unix domain socket, or named pipe without verifying the caller's process ID, UID, or cryptographic token.
  - *Audit Check:* On Windows named pipes and Unix domain sockets, inspect OS-level ACLs. On local HTTP servers, require a random per-session authorization bearer token generated at startup.
- **Claimed Principal vs Channel Identity:**
  - *Vector:* An IPC message payload includes `{ userId: 1 }` and the server trusts it without checking which OS user or process actually owns the connection.
  - *Audit Check:* Derive principal identity strictly from connection-level credentials (e.g. `SO_PEERCRED` on Linux, token on Windows), never from user-supplied payload fields.
- **Predictable Request IDs & Shared Memory Corruption:**
  - *Vector:* Local IPC channels use predictable sequential IDs or world-writable temporary files/locks, allowing another unprivileged process to hijack or tamper with responses.
  - *Audit Check:* Use cryptographically secure UUIDs for correlation and set restrictive permissions (`0600`) on socket files and shared memory segments.
