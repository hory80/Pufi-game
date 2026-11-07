// Crawler: deschide fiecare zonă, fiecare card (joc) și primul sub-card (nivel); raportează erori JS și texte stricate.
const {chromium}=require('playwright');
(async()=>{ const b=await chromium.launch(); const langs=(process.argv[2]||'ro').split(','); const vp=process.argv[3]==='ph'?{width:390,height:844}:{width:1180,height:820};
const p=await b.newPage({viewport:vp}); let errs=[]; p.on('pageerror',e=>errs.push(e.message.slice(0,140)));
await p.addInitScript(()=>{ window.__vroot=()=>{ const L=[...document.querySelectorAll('[id$="-root"]')].filter(x=>!x.hidden&&getComputedStyle(x).display!=='none'&&x.getBoundingClientRect().width>0); return L.length?L[L.length-1]:document.body; }; });
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(1200);
const OPEN=['openMath','openSoroban','openArena','openReading','openTime','openShapes','openRobo','openChess','openIsland'];
const scan=()=>p.evaluate(()=>{ const r=window.__vroot();
  const t=r.innerText||''; const bad=(t.match(/[^\n]{0,40}(undefined|NaN|\[object|null\b)[^\n]{0,30}/g)||[]);
  const ov=[...r.querySelectorAll('*')].filter(e=>{ const s=getComputedStyle(e); if(s.overflow!=='visible'||!e.children.length&&!e.textContent.trim()) return false; const q=e.getBoundingClientRect(); return q.width>0&&(q.right>innerWidth+4||q.left<-4)&&e.closest('button'); }).length;
  return {id:r.id,bad,ov}; });
const cards=()=>p.evaluate(()=>{ const r=window.__vroot();
  return [...r.querySelectorAll('button')].filter(x=>{ const q=x.getBoundingClientRect(); return q.width>70&&getComputedStyle(x).visibility!=='hidden'&&q.height>60&&!/back|înapoi|zurück|⬅|←/i.test(x.className+x.textContent.slice(0,12))&&!x.closest('header,.rb-top,.tm-top,.top'); }).length; });
const clickCard=i=>p.evaluate(i=>{ const r=window.__vroot();
  const l=[...r.querySelectorAll('button')].filter(x=>{ const q=x.getBoundingClientRect(); return q.width>70&&getComputedStyle(x).visibility!=='hidden'&&q.height>60&&!/back|înapoi|zurück|⬅|←/i.test(x.className+x.textContent.slice(0,12))&&!x.closest('header,.rb-top,.tm-top,.top'); }); if(l[i]){ const t=l[i].innerText.replace(/\s+/g,' ').slice(0,30); l[i].click(); return t; } return null; },i);
const close=()=>p.evaluate(()=>{ try{ speechSynthesis.cancel(); }catch(e){} document.querySelectorAll('[id$="-root"]').forEach(x=>x.hidden=true); });
for(const L of langs){ const rep=[]; await p.evaluate(l=>window.__switchLang&&window.__switchLang(l),L);
  for(const o of OPEN){ await close(); const ok=await p.evaluate(o=>{ if(typeof window[o]!=='function') return false; window.started=true; window[o](); return true; },o); if(!ok){ rep.push(o+': lipsește'); continue; } await p.waitForTimeout(500);
    const n=Math.min(await cards(),+(process.env.MAXC||16)); console.error(o,'cards',n,await p.evaluate(()=>window.__vroot().id)); const s0=await scan(); if(s0.bad.length) rep.push(o+' meniu: '+s0.bad.join(' | ')); if(errs.length) rep.push(o+' meniu ERR '+errs.splice(0).join(' / '));
    for(let i=0;i<n;i++){ await close(); await p.evaluate(o=>window[o](),o); await p.waitForTimeout(350); const t=await clickCard(i); if(!t) continue; await p.waitForTimeout(900);
      let s=await scan(); if(s.bad.length) rep.push(`${o} › ${t}: ${s.bad.join(' | ')}`); if(errs.length) rep.push(`${o} › ${t} ERR ${errs.splice(0).join(' / ')}`);
      const m=await cards(); if(m>0&&m<40){ const t2=await clickCard(0); await p.waitForTimeout(1300); s=await scan(); if(s.bad.length) rep.push(`${o} › ${t} › ${t2}: ${s.bad.join(' | ')}`); if(errs.length) rep.push(`${o} › ${t} › ${t2} ERR ${errs.splice(0).join(' / ')}`); }
      if(process.env.MONKEY){ for(let k=0;k<+process.env.MONKEY;k++){ await p.evaluate(()=>{ const r=window.__vroot(); const L=[...r.querySelectorAll('button,[data-part],.rb-card,.tm-opt button,.rd-hcard,svg text,svg circle,svg rect,svg g[class]')].filter(x=>{ const q=x.getBoundingClientRect(); return q.width>8&&q.height>8&&q.top>0&&q.top<innerHeight&&!/înapoi|back|zurück|părinți|parents|eltern|🏠|⬅|✖/i.test((x.innerText||x.textContent||'').slice(0,14))&&!x.closest('#rb-ov,.ov,[id$="Ov"],header,.rb-top,.tm-top'); });
          window.__mk=(window.__mk||0)+1; window.__mkL=L.length; window.__mk=(window.__mk||0)+1; window.__mkL=L.length; if(!L.length) return; const e=L[Math.floor(Math.random()*L.length)], q=e.getBoundingClientRect(); const x=q.left+q.width/2, y=q.top+q.height/2; const t=document.elementFromPoint(x,y)||e;
          ['pointerdown','mousedown','pointerup','mouseup','click'].forEach(ty=>t.dispatchEvent(new (ty.startsWith('pointer')?PointerEvent:MouseEvent)(ty,{bubbles:true,clientX:x,clientY:y,pointerId:1}))); }); await p.waitForTimeout(220); }
        await p.waitForTimeout(600); if(process.env.DBG) console.error(o,t,'monkey',await p.evaluate(()=>[window.__mk,window.__mkL,(window.__vroot().querySelector('.rb-bubble,.bubble,h2')||{}).textContent].join(' :: ').slice(0,150))); s=await scan(); if(s.bad.length) rep.push(`${o} › ${t} › monkey: ${s.bad.join(' | ')}`); if(errs.length) rep.push(`${o} › ${t} › monkey ERR ${[...new Set(errs.splice(0))].join(' / ')}`); } } }
  console.log('=== '+L+' ('+vp.width+'): '+(rep.length?'\n'+rep.join('\n'):'ok')); }
await b.close(); })();
