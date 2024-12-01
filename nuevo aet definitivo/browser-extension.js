// manifest.json
{
  "manifest_version": 3,
  "name": "AET Security Suite",
  "version": "1.0.0",
  "description": "Protección avanzada para navegación web",
  "permissions": [
    "webRequest",
    "webRequestBlocking",
    "tabs",
    "storage",
    "notifications"
  ],
  "host_permissions": [
    "<all_urls>"
  ],
  "background": {
    "service_worker": "background.js"
  },
  "action": {
    "default_popup": "popup.html",
    "default_icon": {
      "16": "icons/icon16.png",
      "48": "icons/icon48.png",
      "128": "icons/icon128.png"
    }
  },
  "icons": {
    "16": "icons/icon16.png",
    "48": "icons/icon48.png",
    "128": "icons/icon128.png"
  }
}

// background.js
let securityRules = {
  maliciousPatterns: [
    /eval\([^)]*\)/,
    /document\.write\([^)]*\)/,
    /<script>[^<]*<\/script>/
  ],
  suspiciousHeaders: [
    'x-xss-protection: 0',
    'x-frame-options: deny'
  ],
  blockedDomains: []
};

chrome.runtime.onInstalled.addListener(() => {
  chrome.storage.local.set({
    securityLevel: 'high',
    notifications: true,
    blockedThreats: 0,
    lastScan: null
  });
});

chrome.webRequest.onBeforeRequest.addListener(
  function(details) {
    // Análisis de solicitud
    const url = new URL(details.url);
    
    // Verificar dominio bloqueado
    if (securityRules.blockedDomains.includes(url.hostname)) {
      notifyThreat('Dominio bloqueado', `Se bloqueó el acceso a ${url.hostname}`);
      return { cancel: true };
    }
    
    // Análisis de contenido
    if (details.type === 'script') {
      const hasInfection = securityRules.maliciousPatterns.some(pattern => 
        pattern.test(details.url)
      );
      
      if (hasInfection) {
        notifyThreat('Script malicioso detectado', `Se bloqueó un script malicioso en ${url.hostname}`);
        return { cancel: true };
      }
    }
    
    return { cancel: false };
  },
  { urls: ["<all_urls>"] },
  ["blocking"]
);

function notifyThreat(title, message) {
  chrome.storage.local.get('notifications', function(data) {
    if (data.notifications) {
      chrome.notifications.create({
        type: 'basic',
        iconUrl: 'icons/icon128.png',
        title: title,
        message: message
      });
    }
  });
  