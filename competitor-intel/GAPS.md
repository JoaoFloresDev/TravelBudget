# GAPS — travel expense tracker / travel budget (consumer) — US + BR
Data: 2026-08-19 · Fontes: competitor_intel.py (us: "travel budget", br: "gastos viagem") + fetch por id (Trabee 673659438, PocketTrip 6790391987) + reviews via iTunes RSS (reviews_*.json neste dir)

Concorrentes analisados (corporativos ignorados; TripIt/Wanderlog/Splitwise/Mobills = outro nicho, só referência visual):
- **TravelSpend** (1434284824) — líder. 4.81/2005 US, 4.89/729 BR
- **Tripcoin** (896518806) — 4.80/912 US, 4.87/1197 BR (forte no BR!)
- **Trabee Pocket** (673659438) — 4.41/93 US, veterano 2013
- **PocketTrip** (6790391987) — indie novo (jul/2026), 0 ratings, feature-set mais moderno do nicho
- **Cuanti** (1658933028) — pequeno BR-friendly, 4.6/40, foco grupo
- **TravelBudget** (1457443074) — micro app, 4.4/10

## (a) Table stakes — TODOS shippam
Multi-moeda com conversão automática pra moeda-casa · orçamento por viagem (total + diário) · categorias com ícone/emoji · funciona offline · gráfico donut por categoria + lista por dia · barra de progresso gasto/orçamento · export CSV (às vezes pago) · freemium.

## (b) Matriz de features
| Feature | TravelSpend | Tripcoin | Trabee | PocketTrip | Cuanti/peq. |
|---|---|---|---|---|---|
| Multi-moeda auto | ✅ | ✅ 150+, taxas históricas+custom | 💰 Pro | ✅ live+cache offline+rate lock | ✅ |
| Budget por viagem (total+diário) | ✅ | ✅ | ✅ básico | ✅ + forecast + "safe to spend" | ✅ |
| Categorias custom | ✅ | ✅ | 💰 Pro | 22 built-in, custom=Pro | ✅ |
| Offline | ✅ | ✅ | ✅ | ✅ | ✅ |
| Split/grupo (quem deve a quem) | ✅ sync real-time | ❌ | ❌ | ✅ (sem conta, local) | ✅ (é o pitch do Cuanti) |
| Daily budget "quanto sobra hoje" | ✅ média | ✅ | ✅ | ✅ hero do print 1 | ~ |
| Mapa de gastos | ~ (por país) | ✅ localização | 💰 place tag | ✅ mapa interativo | ❌ |
| Estatísticas/trends | ✅ trend+países | ✅ | 💰 Pro (pie chart!) | ✅ dashboard custom | ✅ |
| Export CSV/PDF | ✅ CSV | ✅ Excel | 💰 Pro (e CSV RUIM — 1 coluna) | ✅ CSV+PDF+boarding pass | ❌ |
| Foto de recibo | ✅ | ✅ (quebrou em update) | ✅ | ✅ + AI scan on-device (Pro) | ❌ |
| Widget home/lock | ❌ (pedido em review BR!) | ❌ | ❌ | ✅ | ❌ |
| Apple Watch | ❌ | ❌ | ❌ | ❌ | ❌ |
| iCloud sync sem conta | ❌ (conta própria — fonte de dor) | ~ backup manual Dropbox/iCloud (reviews: "no iCloud backup") | ❌ conta/login (perde dados) | ✅ CloudKit puro | ❌ |
| Despesa multi-dia (diluir hotel/voo) | ✅ | ✅ | ❌ | ✅ | ❌ |
| Cash vs cartão | ~ | ✅ métodos custom | ✅ (diferencial dele) | ✅ | ❌ |

**Wedges (ninguém ou quase ninguém entrega bem):**
1. **Widget** de "posso gastar hoje" — só o PocketTrip (zero ratings); os líderes não têm e users pedem.
2. **Apple Watch** — NINGUÉM no nicho.
3. **Local-first sem login + iCloud** — os 3 líderes têm história de perda de dados/conta; confiança é o wedge nº 1.
4. **Grátis de verdade** — todo líder aperta paywall (dor recorrente); GambitStudio nasce grátis = arma direta.
5. **Export decente grátis** (CSV bem formatado + PDF bonito) — Trabee cobra e entrega mal.
6. **Câmbio confiável e transparente** (taxa cacheada com data visível, lock no dia do gasto) — reviews reclamam de taxa errada nos 2 líderes.

## (c) Naming pattern
- **US:** `[Marca curta] : Travel Budget [App]` — TravelSpend: Travel Budget App · Tripcoin - Travel budget · Trabee Pocket - Travel Budget · PocketTrip: Travel Budget. "Travel budget" É o token do name; subtitle pega "expense/spending/trip".
- **BR:** `[Marca] - Gastos de viagem | Orçamento de viagem | Custos de Viagem` — marca fica em inglês, keyword 100% localizada. Tripcoin BR subtitle: "Orçamento de férias com amigos"; Cuanti: "Rastreador de gastos de férias" (férias = segundo token relevante).

## (d) Padrões visuais que convertem
- **Dois looks dominantes:** (1) fundo claro creme/off-white com headline preta grande + palavra-chave em cor de acento (TravelSpend bege/rosa-vinho; PocketTrip creme/azul — o mais bonito do nicho); (2) fundo sólido saturado de marca com headline branca (Tripcoin teal #0AA; Trabee gradiente roxo-azul).
- **Print 1 = dashboard da viagem** com barra de progresso orçamento + donut de categorias + números grandes ("$3.748/30.000", "REMAINING $2.035"). Headline com a keyword: "Track your travel budget" / "Veja o orçamento da sua viagem".
- **Print 2 = quick add** ("Enter expenses quickly / Log expenses in seconds") mostrando conversão de moeda inline.
- **Print 3 = stats/daily budget** ("Analyze your spending" / "Know your daily budget").
- Prints seguintes: split de grupo (avatares + quem deve a quem), mapa de gastos, moedas.
- Kicker pequeno em caps acima do headline (PocketTrip: "TRAVEL MORE. STRESS LESS.", "QUICK ADD") + linha pontilhada de rota de avião como decoração — vocabulário visual "viagem" (pin, avião, cartão de embarque, barcode).
- BR: headlines totalmente traduzidos (TravelSpend e Tripcoin localizam tudo; UI interna às vezes fica EN — chance de "100% em português").
- Fotos de destino como capa de trip card (Trabee, Cuanti, PocketTrip) humanizam o print 1.

## (e) Dores de review → nosso diferencial
| Dor recorrente (app, loja) | Diferencial nosso |
|---|---|
| Perda de dados: update apagou viagens/notas (Tripcoin US+BR), "logou e sumiu tudo" (Trabee), "despesas desapareceram, sou premium" (TravelSpend BR) | Local-first + iCloud automático, SEM login; dado nunca sai do controle do user |
| Sem backup/sync entre devices (Tripcoin: "no iCloud backup… lose the data") | CloudKit sync nativo desde v1 |
| Paywall agressivo: Trabee free = só 1º dia de viagem; TravelSpend desativa viagens antigas no free e cobra caro | App 100% grátis (padrão GambitStudio) — mensagem "sem assinatura" na description |
| Câmbio errado/desatualizado (TravelSpend US, Tripcoin US) | Taxa com data visível, cache offline, lock da taxa no dia do gasto, taxa manual opcional |
| Falta widget (TravelSpend BR: "really miss widgets") | Widget home+lock "quanto posso gastar hoje" (e print dedicado) |
| Export inútil (Trabee: CSV de 1 coluna, PDF não usável) | CSV colunar decente + resumo compartilhável, grátis |
| Redesign quebra hábito / app não abre (Trabee BR/US, TravelSpend BR, Tripcoin US "white screen") | UI estável, simples, sem conta = menos pontos de falha |
| Pede review sem parar (Tripcoin US) | ReviewService do lab (1x, momento de vitória) |
| Apple Pay import duplica transações (TravelSpend BR) | Sem auto-import mágico na v1 — entrada manual rápida e confiável |

## (f) Monetização (referência — nosso app nasce grátis)
- **TravelSpend:** freemium + assinatura Premium (multi-trip/sync/grupo); free vem apertando (viagens antigas bloqueadas) → churn visível nos reviews.
- **Tripcoin:** historicamente grátis/one-time barato; sem sub agressiva — por isso amado; monetização fraca = app estagnado (update quebrou).
- **Trabee Pocket:** Pro por compra (multi-moeda, categorias custom, charts, export) + gate duríssimo no free (1º dia só) → 1★ BR.
- **PocketTrip:** free = 1 viagem por vez; Pro sub = unlimited + AI scan + live rates + custom categories.
- Padrão do nicho: freemium com paywall em multi-viagem/multi-moeda/export. Ser grátis nos 3 é posicionamento único imediato.
