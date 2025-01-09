// background.js
let securityRules = {
  maliciousPatterns: [],
  suspiciousHeaders: [],
  blockedDomains: [],
  securityLevel: 'high'
};

class AETSecurityExtension {
  constructor() {
    this.initializeExtension();
    this.startMonitoring();
  }

  async initializeExtension() {
    // Cargar reglas desde el servidor
    const rules = await this.fetchSecurityRules();
    securityRules = { ...securityRules, ...rules };

    // Configurar listeners
    chrome.webRequest.onBeforeRequest.addListener(
      this.handleWebRequest.bind(this),
      { urls: ["<all_urls>"] },
      ["blocking"]
    );

    chrome.runtime.onMessage.addListener(
      this.handleMessage.bind(this)
    );
  }

  async handleWebRequest(details) {
    const analysis = await this.analyzeRequest(details);
    
    if (analysis.blocked) {
      this.notifyUser({
        type: 'blocked_request',
        details: analysis.reason
      });
      return { cancel: true };
    }

    if (analysis.warning) {
      this.notifyUser({
        type: 'security_warning',
        details: analysis.warning
      });
    }

    return { cancel: false };
  }

  async analyzeRequest(details) {
    const url = new URL(details.url);
    
    // Verificar dominio bloqueado
    if (this.isDomainBlocked(url.hostname)) {
      return {
        blocked: true,
        reason: 'blocked_domain'
      };
    }

    // Analizar patrones maliciosos
    if (this.hasMaliciousPattern(details)) {
      return {
        blocked: true,
        reason: 'malicious_pattern'
      };
    }

    // Verificar certificados
    const certStatus = await this.verifyCertificate(url);
    if (!certStatus.valid) {
      return {
        warning: 'invalid_certificate',
        details: certStatus.reason
      };
    }

    return { safe: true };
  }

  // Popup.js
  setupPopup() {
    const popup = `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <style>
          body {
            width: 300px;
            padding: 16px;
            font-family: -apple-system, system-ui, "Segoe UI", Roboto, sans-serif;
            background: #0f172a;
            color: white;
          }
          .header {
            display: flex;
            align-items: center;
            margin-bottom: 16px;
          }
          .icon {
            width: 32px;
            height: 32px;
            margin-right: 12px;
          }
          .status {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 16px;
            background: rgba(255,255,255,0.1);
          }
          .status.safe {
            border-left: 4px solid #22c55e;
          }
          .status.warning {
            border-left: 4px solid #eab308;
          }
          .status.danger {
            border-left: 4px solid #ef4444;
          }
          .button {
            width: 100%;
            padding: 8px;
            background: #6366f1;
            border: none;
            border-radius: 6px;
            color: white;
            cursor: pointer;
            margin-top: 8px;
          }
          .button:hover {
            background: #4f46e5;
          }
        </style>
      </head>
      <body>
        <div class="header">
          <img src="icon.png" class="icon">
          <h2>AET Security</h2>
        </div>
        <div id="status" class="status safe">
          <h3>Protected</h3>
          <p>Your connection is secure</p>
        </div>
        <div id="stats">
          <p>Threats blocked today: <span id="threats">0</span></p>
          <p>Security level: <span id="level">High</span></p>
        </div>
        <button class="button" id="scan">Scan Page</button>
        <button class="button" id="settings">Settings</button>
        <script src="popup.js"></script>
      </body>
      </html>
    `;
    
    return popup;
  }

  // content.js
  injectSecurityOverlay() {
    const overlay = document.createElement('div');
    overlay.id = 'aet-security-overlay';
    overlay.style.cssText = `
      position: fixed;
      top: 0;
      right: 0;
      background: rgba(15, 23, 42, 0.95);
      padding: 16px;
      border-radius: 0 0 0 8px;
      z-index: 999999;
      font-family: -apple-system, system-ui, "Segoe UI", Roboto, sans-serif;
      color: white;
      display: none;
    `;

    document.body.appendChild(overlay);
    return overlay;
  }

  updateSecurityStatus(status) {
    const overlay = document.getElementById('aet-security-overlay');
    if (!overlay) return;

    overlay.innerHTML = `
      <div style="display: flex; align-items: center; margin-bottom: 8px;">
        <img src="${status.icon}" style="width: 24px; height: 24px; margin-right: 8px;">
        <strong>${status.message}</strong>
      </div>
      <div style="font-size: 12px; color: #94a3b8;">
        ${status.details}
      </div>
    `;

    overlay.style.display = 'block';
    setTimeout(() => {
      overlay.style.display = 'none';
    }, 5000);
  }
}

// Inicializar la extensión
const aetExtension = new AETSecurityExtension();
