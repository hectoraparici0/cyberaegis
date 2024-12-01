# Configuración de DNS para hapariciop.uk

1. Accede a tu panel de Cloudflare
2. Ve a la sección DNS
3. Añade los siguientes registros:

## Registro A
- Nombre: @
- Dirección IPv4: 192.0.2.1 (será reemplazada por Cloudflare)
- Proxy status: Proxied

## Registro CNAME
- Nombre: www
- Target: hapariciop.uk
- Proxy status: Proxied

4. Verifica que los nameservers de tu dominio están apuntando a Cloudflare:
   - ns1.cloudflare.com
   - ns2.cloudflare.com
