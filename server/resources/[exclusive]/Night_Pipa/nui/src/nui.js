const resourceName = () => {
  try {
    if (typeof GetParentResourceName === 'function') {
      return GetParentResourceName()
    }
  } catch (_) { }
  return 'Night_Pipa'
}

export async function post(event, data = {}) {
  const res = await fetch(`https://${resourceName()}/${event}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data),
  })
  try {
    return await res.json()
  } catch (_) {
    return { ok: true }
  }
}

export function onNuiMessage(handler) {
  const listener = (event) => {
    const data = event.data
    if (!data || !data.action) return
    handler(data)
  }
  window.addEventListener('message', listener)
  return () => window.removeEventListener('message', listener)
}
