# Análise pré-launch — Travel Budget (gastos de viagem) · Decisões pros 3 campos ASO

- **Data:** 2026-08-19 · **Source:** Astro MCP (tracking no TravelSpend id 1434284824) + iTunes lookup + competitor-scout (prints/reviews lidos)
- **Baseline:** — (pré-launch, app não existe)
- **Filtro de decisão:** pop ≥ 6 + diff ≤ 20 + intenção alinhada = sweet spot; heads diff 21-40 com incumbente fraco = alvo de subida; diff > 40 head corporativo = só palavra única no pool

## 🚦 VEREDITO: 🟡 RISKY → GO (US-first; BR/ES secundários)

| Sinal | Resultado |
|---|---|
| Oxigênio ASO | 2 sweet spots estritos: `travel budget` BR (pop 6/diff 15, busca EM INGLÊS no BR), `daily budget` US (7/17, intenção parcial). Heads US `travel budget` 12/35 e `travel money` 7/42 GANHÁVEIS: diff inflado por corporativos (Expensify 156k, Concur 1.1M ratings = intenção business expense report, outro nicho) — o incumbente consumer TravelSpend tem só 2.005 ratings |
| Saturação dos heads | NÃO saturado no consumer: líder 2k ratings, campo fragmentado (dezenas de apps 0-rating) |
| Wedge | FORTE e baseado em dados (ver 🥊 abaixo): widget safe-to-spend (ninguém tem + pedido em review), local-first sem login (3 líderes perdem dados), grátis de verdade (todos apanham por paywall), export grátis decente, câmbio transparente datado |
| 💰 Líder fatura | Todos freemium com subscription shipada (TravelSpend Premium, Trabee Pro, PocketTrip Pro). Velocity do líder ~21 ratings/mês (2018→hoje) — volume moderado mas nicho paga. Sem rebaixamento de veredito |

## Pesos dos 3 campos
| Campo | Peso | Regra |
|---|---|---|
| Name (30) | 7× | só keyword pesada, zero conectivo vazio |
| Subtitle (30) | 3× | complementa, NUNCA duplica o name |
| Keywords (100) | 1× | single words, sem dup, packed ~95-100 |

Anti-dup: Apple não acumula peso de palavra repetida entre campos; combina tokens automaticamente (cartesiano).

## 📄 Resultado final (proposta v1)

### 🇺🇸 en-US
```
name:     Travel Budget: Trip Expenses      (28)
subtitle: Vacation cost, daily spending     (29)
keywords: money,wallet,holiday,planner,converter,currency,split,diary,log,backpacking,euro,tracker,honeymoon   (98)
```
Composições-alvo: `travel budget` (12/35, alvo top 5) · `daily budget` = daily+Budget (7/17, alvo TOP 3) · `trip cost` (5/21) · `travel cost` (5/60 feeder) · `trip expenses` (5/40) · `vacation budget` (5/47) · `travel expense tracker` = tracker no pool (5/50) · `travel money` = money no pool (7/42) · `travel wallet` (6/36) · `backpacking budget` (5/17, TOP 3) · `honeymoon budget` (5/13, TOP 3).

### 🇧🇷 pt-BR
```
name:     Gastos de Viagem: Orçamento       (27)
subtitle: Despesas, férias e moedas         (25)
keywords: dinheiro,conversor,dolar,euro,custos,carteira,diario,mochilao,internacional,dividir,cotacao,viajar   (98)
```
Composições-alvo: `travel budget` BR (6/15 — TOP 3; termo EN buscado no BR, padrão sunrise-alarm) — coberto? NÃO em pt-BR name; fica coberto pelo en-US name via cross-locale indexing do BR (App Store BR indexa en-US + pt-BR) ✅ · `gastos de viagem`/`gastos viagem` (5/39-40, TOP 3) · `orçamento de viagem` (5/15-21, TOP 1-3) · `gastos ferias` = férias no subtitle (5/13, TOP 3) · `custos de viagem` (5/13, TOP 3) · `dinheiro viagem` (5/13, TOP 3) · `despesas de viagem` (5/21) · `conversor de moedas` (51/52 — feeder, sem alvo solo).

### 🇪🇸 es-ES
```
name:     Gastos de Viaje: Presupuesto      (28)
subtitle: Dinero, divisas y vacaciones      (28)
keywords: conversor,moneda,cambio,diario,mochilero,cartera,ahorro,registro,euro,dolar,contador,internacional   (98)
```
Composições-alvo: `gastos de viaje` (11/48, alvo top 5 — líder TravelSpend #2 com 321 ratings ES) · `presupuesto de viaje`/`presupuesto viaje` (5/15-21, TOP 1-3) · `presupuesto vacaciones` (5/11, TOP 1) · `dinero de viaje` (5/45) · `presupuesto diario` = diario? NÃO compõe (diario=diary); aceito — presupuesto+diario compõe sim em token (5/7, bônus).

## Cobertura por cluster (peso composto name×7 + sub×3 + kw×1)
| Cluster | US | BR | ES |
|---|---|---|---|
| budget/orçamento core | name 7× | name 7× | name 7× |
| expense/gastos core | name 7× (Expenses) | name 7× (Gastos) | name 7× (Gastos) |
| viagem/travel/trip | name 7× (Travel+Trip) | name 7× (Viagem) | name 7× (Viaje) |
| moeda/currency | kw 1× (currency, converter, euro) | sub 3× (moedas) + kw | sub 3× (divisas) + kw |
| férias/vacation | sub 3× (Vacation) | sub 3× (férias) | sub 3× (vacaciones) |
| daily/diário | sub 3× (daily) | kw 1× (diario) | kw 1× (diario) |

## 🎯 Hipótese formal
If we launch com name keyword-first "Travel Budget: Trip Expenses" (+ locais) num nicho cujo incumbente consumer tem só 2k ratings, then alcançamos top 5 em `travel budget` US e TOP 1-3 nos long-tails BR/ES de intenção exata em 30-60 dias (honeymoon period), because a relevância de name 7× + campo fragmentado + wedge de produto (widget/local-first/grátis) convertem melhor que os líderes paywall-pesados.

## ⚠️ Riscos
1. **Volume real modesto** — quase tudo pop 5 (floor) fora dos heads; receita depende de ganhar o head `travel budget` US (pop 12) e do honeymoon boost. Mitigação: ASA Discovery semana 1 + segundo set de keywords pronto.
2. Diff do head vem de corporativos gigantes — se a Apple misturar intenções no SERP, o teto de posição é ~#4-5 (atrás de Expensify/Concur).
3. Sazonalidade (picos jun-ago / dez-jan hemisfério norte; dez-fev BR). Launch em agosto pega cauda da temporada US.
4. `roteiro de viagem` BR (23/23) e `conversor de moedas` BR (51/52) são de OUTRA intenção — NÃO perseguir como alvo (mismatch = uninstall).

## 🌎 Resumo cross-locale
| Market | Melhor alvo | Pop/Diff | Posição esperada |
|---|---|---|---|
| US | travel budget | 12/35 | top 5 (60d) |
| US | daily budget | 7/17 | TOP 3 |
| US | backpacking/honeymoon budget | 5/13-17 | TOP 1-3 |
| BR | travel budget (EN no BR) | 6/15 | TOP 3 |
| BR | orçamento/custos/dinheiro viagem | 5/13-21 | TOP 1-3 |
| ES | gastos de viaje | 11/48 | top 5 |
| ES | presupuesto vacaciones | 5/11 | TOP 1 |

Receita estimada (ARPU GambitStudio ~US$10/ano em 2-4% se monetizar depois; v1 grátis = foco em downloads): 6 meses ~8-20 dl/dia agregado (conservador-realista) se top 5 no head US + TOP 3 nos long-tails; 12 meses depende de iterar ASO + widget/watch como diferencial de review.

## 🥊 Benchmark competitivo (competitor-scout 2026-08-19; detalhe em competitor-intel/GAPS.md)

### Features-gap
| Feature | TravelSpend | Tripcoin | Trabee | PocketTrip | Nós |
|---|:-:|:-:|:-:|:-:|:-:|
| Multi-moeda auto | ✅ | ✅ | 💰 | ✅ | ✅ |
| Budget total+diário | ✅ | ✅ | básico | ✅ | ✅ |
| Offline | ✅ | ✅ | ✅ | ✅ | ✅ |
| Split/grupo | ✅ | ❌ | ❌ | local | v1.x |
| Export CSV/PDF grátis | CSV | Excel | 💰 ruim | CSV+PDF | ✅ ← wedge |
| **Widget** | ❌ | ❌ | ❌ | ✅ | ✅ ← **wedge** |
| **Watch** | ❌ | ❌ | ❌ | ❌ | v1.x ← wedge futuro |
| Local-first sem login | ❌ | manual | ❌ | ✅ | ✅ ← **wedge** |

### Naming pattern
US: `Marca: Travel Budget` (4 de 5 líderes têm "travel budget" no name). BR: keyword localizada "Gastos/Orçamento/Custos de viagem", "férias" 2º token. Nossos names casam com o padrão sem clonar ninguém. ✅

### Monetização do nicho (referência — nascemos grátis)
Freemium subs em todos: TravelSpend Premium (free encolhendo), Trabee Pro (free = 1º dia da viagem → 1★), PocketTrip Pro (free = 1 viagem), Tripcoin quase grátis (amado, estagnado). **Grátis nos 3 pontos do paywall (multi-viagem, multi-moeda, export) = posicionamento único.**

### Dor do líder → diferencial nosso
1. Perda de dados em update/login (3 líderes) → local-first, zero conta
2. Paywall agressivo → grátis de verdade
3. Câmbio errado/desatualizado → taxa datada + lock no dia do gasto
4. Sem widget → widget "quanto posso gastar hoje" (home + lock screen)
5. Export inútil (Trabee CSV 1 coluna) → CSV decente grátis
6. Review-nag (Tripcoin) → pedido único via ReviewService
7. UI dos líderes vaza EN no BR → 100% localizado pt-BR

## Próximos passos
- Segundo set de keywords (rotação day 7-14) → Fase 2 (`metadata/_research/keywords_round2_<locale>.txt`)
- Launch playbook: seg-qua, 5 reviews em 72h, ASA Discovery $5-15/dia semana 1
