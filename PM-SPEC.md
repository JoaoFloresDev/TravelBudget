# TravelBudget — PM Spec (F1, 2026-08-19)

Travel expense tracker consumer. Grátis, sem login, local-first. Markets: US (primário), BR, ES.
Wedges (do benchmark): widget "quanto posso gastar hoje" · local-first sem conta (dados nunca somem) · grátis nos 3 pontos de paywall do nicho (multi-viagem, multi-moeda, export) · câmbio datado + travado por gasto · CSV grátis · 100% localizado.

## Features v1
1. **Trips** — criar/editar/apagar viagem: nome, emoji (12 presets), datas início/fim, moeda-base (default do device), orçamento total opcional. Estados upcoming/active/past; pin manual (UserDefaults). currentTrip = pinned > ativa por data > mais recente.
2. **Expenses** — registro em ≤3 taps: valor grande + teclado decimal focado, moeda (default = última usada), grid de 8 categorias (food/transport/lodging/activities/shopping/fees/health/other), nota opcional, data, cash/card. Editar/apagar com confirm.
3. **Câmbio** — open.er-api.com (keyless), cache 12h offline-first por moeda-base; conversão trava rate+data no gasto; rate editável manualmente; fallback manual quando offline sem cache.
4. **Dashboard (TripDetail)** — restante grande, "posso gastar hoje" (BudgetEngine: (budget − gasto antes de hoje) / dias restantes incl. hoje), progress bar, donut por categoria, lista de gastos agrupada por dia, export CSV via ShareLink, menu editar viagem.
5. **Stats tab** — picker de viagem em chips, 3 tiles (total, média/dia, alvo diário), bar chart diário vs linha do alvo (Swift Charts), breakdown por categoria, split cash/card.
6. **Widget** (WidgetKit, App Group `group.com.gambitstudio.travelbudget`) — small: saldo do dia; medium: + progress e gasto hoje. Snapshot JSON compartilhado, reload no save + meia-noite.
7. **Onboarding** — OnboardingKit 3 steps (orçamento por viagem / qualquer moeda / widget+privacidade). Sem permissões.
8. **Settings** — template padrão (Appearance/Language/Rate/Privacy/Terms).

## Fora da v1 (decisão consciente)
- iCloud sync (LEARNINGS #3) → v1.x. Watch app → v1.x (wedge futuro). Split/grupo → v1.x. Fotos de recibo → não planejado.

## Navegação
TabView 3 tabs: Trips (NavigationStack, push TripDetail; modais NewTripSheet/AddExpenseSheet) · Stats (sem push) · Settings.
Regra: cria/edita = modal; detalhe = push.

## Paleta (light-first)
bg #F7F6F2 · surface #FFFFFF · primary #0C7489 teal · secondary #0A5A6A · accent #FF7A45 coral · success #129B6C · error #E5484D · text #1B1D22/#6B7280/#A6ACB8. Launch: logo branco (airplane.departure) sobre teal. Ícone: teal gradiente + avião branco + sol coral.

## Gate Report (F3)
| Gate | Status |
|---|---|
| Bundle IDs app+widget via API | ✅ RCN5GHPGZ6 / KHY9672KN8 |
| APP_GROUPS capability via API | ✅ ambos |
| App Group resource no portal + assign | ⏳ João (now.json) — bloqueia archive |
| App record ASC (web UI) | ⏳ João (now.json) — bloqueia upload/submit |
| CI billing GitHub Actions | ✅ (College release/23 rodou 18/08) |
| Pricing / App Privacy / Content rights | web UI no submit (F7) |
| Entitlement restrito | nenhum |

## ASO (F0/F2 — keyword_candidates.md + metadata/)
en-US "Travel Budget: Trip Expenses" · pt-BR "Gastos de Viagem: Orçamento" · es-ES "Gastos de Viaje: Presupuesto". Alvos: travel budget US top5, daily budget US TOP3, travel budget BR TOP3, long-tails BR/ES TOP1-3. Round-2 keywords prontos em metadata/_research/ pra rotação day 7-14.
