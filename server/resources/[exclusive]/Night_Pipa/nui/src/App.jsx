import { useEffect, useState } from 'react'
import { onNuiMessage, post } from './nui'

const DIR_LABEL = {
  0: 'N',
  1: 'L',
  2: 'S',
  3: 'O',
}

function moneyFmt(v) {
  return Number(v || 0).toLocaleString('pt-BR')
}

function KiteIcon({ active }) {
  return (
    <svg
      viewBox="0 0 24 24"
      className={`size-[1.5rem] ${active ? 'pipa-voo-ativa pipa-voo-brilho text-primary' : 'text-t-2'}`}
      fill="currentColor"
    >
      <path d="M12 2l8 10-8 10L4 12 12 2zm0 4.5L7.8 12 12 17.5 16.2 12 12 6.5z" />
    </svg>
  )
}

function ShopPanel({ open, money, kites, lines, tab, setTab, onClose, onBuyKite, onBuyLine, onEquipKite, onEquipLine, onErguer, equipped }) {
  if (!open) return null

  const list = tab === 'pipas' ? kites : lines

  return (
    <div className="fixed inset-0 z-50 flex items-center painel-fundo">
      <div className="m-[1vh] flex h-[92vh] w-[40vh] flex-col overflow-hidden rounded-[1.1rem] border border-line bg-[rgba(4,5,7,.9)]">
        <div className="flex items-center justify-around border-b border-white/10 px-[1.4vh] py-[1.1vh]">
          <div>
            <p className="text-[1.3vh] uppercase tracking-[.1vh] text-t-3">Loja de pipas e linhas</p>
            <h1 className="text-[2.2vh] font-extrabold text-t-1">PIPA</h1>
          </div>
          <div className="text-right">
            <p className="text-[1.2vh] uppercase tracking-[.05vh] text-t-3">Saldo</p>
            <p className="text-[1.8vh] font-bold text-money">R$ {moneyFmt(money)}</p>
          </div>
          <button
            className="trans-btn clip-cut bg-white/10 px-[1.2vh] py-[0.7rem] text-[1.3vh] text-t-2 hover:bg-primary hover:text-secondary"
            onClick={onClose}
          >
            FECHAR
          </button>
        </div>

        <div className="flex gap-[0.8vh] px-[1.4vh] pt-[1.1vh]">
          {['inventario'].map((t) => (
            <button
              key={t}
              className={`trans-btn clip-cut flex-1 py-[0.9rem] text-[1.3vh] font-semibold uppercase tracking-[.04vh] ${
                tab === t ? 'bg-primary text-secondary' : 'bg-panel-2 text-t-2 hover:border-primary border border-transparent'
              }`}
              onClick={() => setTab(t)}
            >
              {t === 'pipas' ? 'Pipas' : t === 'linhas' ? 'Linhas' : 'Inventário'}
            </button>
          ))}
        </div>

        <div className="mt-[1.6vh] min-h-0 flex-1 overflow-y-auto scroll-fina px-[1.4vh] pb-[1.4vh]">
          {tab !== 'inventario' && (
            <div className="flex flex-col gap-[0.8vh]">
              {list.map((item) => (
                <div
                  key={item.id}
                  className="flex items-center gap-[1vh] border border-white/10 bg-fill-1 px-[1.2vh] py-[1rem]"
                >
                  <div className="pipa-mark grid h-[3.6rem] w-[3.6rem] place-items-center bg-primary/[.08] text-primary">
                    <span className="text-[1.2rem] font-bold">{(item.name || '?').slice(0, 1)}</span>
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-[1.4vh] font-semibold text-t-1">{item.name}</p>
                    <p className="text-[1.2vh] text-t-3">
                      {tab === 'pipas'
                        ? `Bônus ${(Number(item.bonus || 0) * 100).toFixed(0)}%`
                        : `Poder ${item.power} · ${item.maxLine}m${item.cuts ? ' · corta' : ''}`}
                    </p>
                  </div>
                  <div className="flex flex-col items-end gap-[0.45rem]">
                    <span className="text-[1.3vh] font-bold text-money">
                      {item.price > 0 ? `R$ ${moneyFmt(item.price)}` : 'Grátis'}
                    </span>
                    <button
                      disabled={item.price === 0 && tab === 'linhas' && item.id === 'comum'}
                      className="trans-btn clip-cut bg-primary px-[1.1rem] py-[0.55rem] text-[1.2vh] font-bold text-secondary hover:brightness-[1.12] disabled:cursor-not-allowed disabled:opacity-40"
                      onClick={() => (tab === 'pipas' ? onBuyKite(item.id) : onBuyLine(item.id))}
                    >
                      COMPRAR
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}

          {tab === 'inventario' && (
            <div className="flex flex-col gap-[1.4vh]">
              <div>
                <p className="mb-[0.8vh] text-[1.3vh] font-bold uppercase tracking-[0.16rem] text-t-3">
                  Minhas pipas
                </p>
                <div className="flex flex-col gap-[0.6vh]">
                  {kites.filter((k) => k.owned || k.qty > 0).length === 0 && (
                    <p className="text-[1.3vh] text-t-3">Nenhuma pipa ainda</p>
                  )}
                  {kites
                    .filter((k) => k.owned || k.qty > 0)
                    .map((k) => (
                      <div
                        key={k.id}
                        className={`flex items-center justify-between border px-[1.2vh] py-[0.9rem] ${
                          k.equipped ? 'border-primary bg-primary/[.08]' : 'border-white/10 bg-fill-1'
                        }`}
                      >
                        <div>
                          <p className="text-[1.4vh] font-semibold text-t-1">{k.name}</p>
                          <p className="text-[1.2vh] text-t-3">x{k.qty || 1}</p>
                        </div>
                        <button
                          className="trans-btn clip-cut border border-primary/70 px-[1rem] py-[0.5rem] text-[1.2vh] text-primary hover:bg-primary hover:text-secondary"
                          onClick={() => onEquipKite(k.id)}
                        >
                          {k.equipped ? 'EQUIPADA' : 'EQUIPAR'}
                        </button>
                      </div>
                    ))}
                </div>
              </div>

              <div>
                <p className="mb-[0.8vh] text-[1.3vh] font-bold uppercase tracking-[0.16rem] text-t-3">
                  Minhas linhas
                </p>
                <div className="flex flex-col gap-[0.6vh]">
                  {lines
                    .filter((l) => l.owned || l.qty > 0)
                    .map((l) => (
                      <div
                        key={l.id}
                        className={`flex items-center justify-between border px-[1.2vh] py-[0.9rem] ${
                          l.equipped ? 'border-primary bg-primary/[.08]' : 'border-white/10 bg-fill-1'
                        }`}
                      >
                        <div>
                          <p className="text-[1.4vh] font-semibold text-t-1">{l.name}</p>
                          <p className="text-[1.2vh] text-t-3">Poder {l.power}</p>
                        </div>
                        <button
                          className="trans-btn clip-cut border border-primary/70 px-[1rem] py-[0.5rem] text-[1.2vh] text-primary hover:bg-primary hover:text-secondary"
                          onClick={() => onEquipLine(l.id)}
                        >
                          {l.equipped ? 'EQUIPADA' : 'EQUIPAR'}
                        </button>
                      </div>
                    ))}
                </div>
              </div>

              <button
                disabled={!equipped?.kite}
                className="trans-btn clip-cut mt-[1vh] bg-primary py-[1.1rem] text-[1.5vh] font-extrabold tracking-[0.1rem] text-secondary hover:brightness-[1.12] disabled:cursor-not-allowed disabled:opacity-40"
                onClick={onErguer}
              >
                ERGUER PIPA
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

function FlightHud({ active, force, meters, dir, storing }) {
  if (!active) return null
  const forcePct = Math.max(0, Math.min(100, Number(force || 0) * 100))

  return (
    <div className="pointer-events-none fixed inset-x-0 bottom-[3rem] z-50 flex justify-center">
      <div className="flex w-[35.2vh] flex-col items-center gap-[0.8vh] rounded-[1.1rem] border border-white/10 bg-[linear-gradient(180deg,rgba(10,10,10,0.92)_0%,rgba(6,6,6,0.94)_100%)] px-[1.5rem] py-[1.1rem]">
        {storing ? (
          <p className="pipa-guardando text-[1.5vh] font-bold uppercase tracking-[0.2rem] text-primary">
            Guardando a pipa
          </p>
        ) : (
          <p className="text-[1.3vh] font-semibold uppercase tracking-[0.16rem] text-t-3">Solta linha</p>
        )}

        <div className="flex w-full items-center gap-[1rem]">
          <KiteIcon active={!storing} />
          <div className="min-w-0 flex-1">
            <div className="mb-[0.35rem] flex items-end justify-between">
              <span className="text-[1.2vh] uppercase text-t-3">Força</span>
              <span className="font-mono text-[1.4vh] text-t-1">{forcePct.toFixed(0)}%</span>
            </div>
            <div className="h-[0.45rem] w-full overflow-hidden rounded-full bg-white/10">
              <div className="h-full bg-primary transition" style={{ width: `${forcePct}%` }} />
            </div>
          </div>
          <div className="text-center">
            <p className="text-[1.2vh] uppercase text-t-3">Dir</p>
            <p className="text-[2vh] font-extrabold text-primary">{DIR_LABEL[dir] || 'S'}</p>
          </div>
          <div className="text-right">
            <p className="text-[1.2vh] uppercase text-t-3">Metros</p>
            <p className="font-mono text-[1.8vh] font-bold text-t-1">{Number(meters || 0).toFixed(1)}m</p>
          </div>
        </div>

        <div className="flex items-center gap-[0.8rem] text-t-3">
          <span className="pipa-arrow-up text-[1.4vh]">▲</span>
          <span className="pipa-wheel text-[1.2vh]">SCROLL</span>
          <span className="pipa-arrow-down text-[1.4vh]">▼</span>
        </div>
      </div>
    </div>
  )
}

function RecolherHud({ active, meters, total }) {
  if (!active) return null
  const pct = Math.max(0, Math.min(100, (1 - Number(meters || 0) / Math.max(1, Number(total || 1))) * 100))
  return (
    <div className="pointer-events-none fixed right-[1.8rem] top-[16rem] z-50 w-[14rem]">
      <p className="mb-[0.45rem] text-[1.2vh] font-semibold uppercase tracking-[0.08rem] text-t-3">Recolhendo</p>
      <div className="h-[0.9rem] w-full overflow-hidden rounded-full bg-white/10">
        <div className="h-full bg-primary transition" style={{ width: `${pct}%` }} />
      </div>
      <p className="mt-[0.35rem] font-mono text-[1.2vh] text-t-2">
        {Number(meters || 0).toFixed(1)} / {Number(total || 0).toFixed(0)}m
      </p>
    </div>
  )
}

function Killfeed({ items }) {
  if (!items.length) return null
  return (
    <div className="pointer-events-none fixed right-[1.8rem] top-[4rem] z-50 flex w-[18rem] flex-col gap-[0.55rem]">
      {items.map((item) => (
        <div
          key={item.id}
          className="pipa-feed-in border border-white/10 bg-[rgba(4,5,7,.9)] px-[1.1rem] py-[0.7rem]"
        >
          <p className="text-[1.2vh] text-t-3">CORTE</p>
          <p className="text-[1.35vh] text-t-1">
            <span className="font-semibold text-primary">{item.quem}</span>
            <span className="text-t-3"> cortou </span>
            <span className="font-semibold text-danger">{item.perdeu}</span>
          </p>
        </div>
      ))}
    </div>
  )
}

export default function App() {
  const [shopOpen, setShopOpen] = useState(false)
  const [tab, setTab] = useState('inventario')
  const [money, setMoney] = useState(0)
  const [kites, setKites] = useState([])
  const [lines, setLines] = useState([])
  const [equipped, setEquipped] = useState({ kite: null, line: null })

  const [flight, setFlight] = useState({
    active: false,
    force: 0,
    meters: 0,
    dir: 2,
    storing: false,
  })
  const [recolher, setRecolher] = useState({ active: false, meters: 0, total: 80 })
  const [feed, setFeed] = useState([])

  useEffect(() => {
    return onNuiMessage((data) => {
      switch (data.action) {
        case 'mostrar': {
          setShopOpen(true)
          setMoney(data.money || 0)
          setKites(data.kites || data.pipas || [])
          setLines(data.lines || data.linhas || [])
          setEquipped(data.equipped || { kite: null, line: null })
          break
        }
        case 'esconder':
          setShopOpen(false)
          break
        case 'voo':
          setFlight({
            active: true,
            force: data.force || 0,
            meters: data.metros ?? data.meters ?? 0,
            dir: data.direcao ?? data.dir ?? 2,
            storing: data.guardando ?? data.storing ?? false,
          })
          break
        case 'vooOff':
          setFlight((s) => ({ ...s, active: false, storing: false }))
          break
        case 'recolher':
          setRecolher({
            active: true,
            meters: data.metros ?? data.meters ?? 0,
            total: data.total ?? data.max ?? 80,
          })
          break
        case 'recolherOff':
          setRecolher((s) => ({ ...s, active: false }))
          break
        case 'killfeed': {
          const id = `${Date.now()}-${Math.random()}`
          setFeed((prev) => {
            const next = [{ id, quem: data.quem, perdeu: data.perdeu }, ...prev].slice(0, 4)
            return next
          })
          setTimeout(() => {
            setFeed((prev) => prev.filter((f) => f.id !== id))
          }, 7000)
          break
        }
        default:
          break
      }
    })
  }, [])

  useEffect(() => {
    const onKey = (e) => {
      if (e.key === 'Escape' && shopOpen) {
        post('fechar')
        setShopOpen(false)
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [shopOpen])

  const applyInventory = (inv) => {
    if (!inv) return
    setMoney(inv.money || 0)
    setKites(inv.kites || [])
    setLines(inv.lines || [])
    setEquipped(inv.equipped || { kite: null, line: null })
  }

  return (
    <>
      <ShopPanel
        open={shopOpen}
        money={money}
        kites={kites}
        lines={lines}
        tab={tab}
        setTab={setTab}
        equipped={equipped}
        onClose={() => {
          post('fechar')
          setShopOpen(false)
        }}
        onBuyKite={async (id) => {
          const res = await post('comprarPipa', { id })
          if (res?.inventory) applyInventory(res.inventory)
        }}
        onBuyLine={async (id) => {
          const res = await post('comprarLinha', { id })
          if (res?.inventory) applyInventory(res.inventory)
        }}
        onEquipKite={async (id) => {
          const res = await post('equiparPipa', { id })
          if (res?.inventory) applyInventory(res.inventory)
        }}
        onEquipLine={async (id) => {
          const res = await post('equiparLinha', { id })
          if (res?.inventory) applyInventory(res.inventory)
        }}
        onErguer={async () => {
          await post('erguer')
          setShopOpen(false)
        }}
      />

      <FlightHud {...flight} />
      <RecolherHud {...recolher} />
      <Killfeed items={feed} />
    </>
  )
}
