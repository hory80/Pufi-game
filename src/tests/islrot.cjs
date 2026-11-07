// Insula: rotirea ecranului cu insula deschisă (portret → peisaj → portret) recalculează scena; o decorațiune în curs de așezare nu se pierde.
const {chromium,webkit}=require('playwright');
(async()=>{ const eng=process.argv[2]==='webkit'?webkit:chromium; let b; try{ b=await eng.launch(); }catch(e){ console.log('motor indisponibil:',process.argv[2]); return; }
const p=await b.newPage({viewport:{width:390,height:844}}); const errs=[]; p.on('pageerror',e=>errs.push(e.message));
await p.addInitScript(()=>{ try{ localStorage.setItem('isl_deco',JSON.stringify([{k:'flowers',x:700,y:700}])); }catch(e){} });
await p.goto('file://'+__dirname+'/index.html'); await p.waitForTimeout(1000);
await p.evaluate(()=>window.openIsland()); await p.waitForTimeout(1200);
const geo=()=>p.evaluate(()=>{ const st=document.getElementById('isl-stage'), sv=st.querySelector('svg'); const r=sv.getBoundingClientRect(), s=st.getBoundingClientRect();
  return {stage:Math.round(s.width)+'x'+Math.round(s.height),svg:Math.round(r.width)+'x'+Math.round(r.height),por:st.classList.contains('por'),scroll:Math.round(st.scrollLeft),vb:sv.getAttribute('viewBox'),acoperă:r.width>=s.width-1&&r.height>=s.height-1,ieseLaStanga:Math.round(r.left-s.left)}; });
const show=async t=>console.log(t.padEnd(26),JSON.stringify(await geo()));
await show('portret');
// începe mutarea decorațiunii (fereastra „Mută”)
await p.evaluate(()=>{ const d=document.querySelector('#isl-stage .isl-d'); d.dispatchEvent(new MouseEvent('click',{bubbles:true})); }); await p.waitForTimeout(300);
await p.evaluate(()=>{ const b=document.querySelector('#isl-pop [data-a=m]'); if(b) b.click(); }); await p.waitForTimeout(300);
console.log('așezare în curs, fereastră vizibilă:',await p.evaluate(()=>!document.getElementById('isl-pop').hidden));
await p.setViewportSize({width:844,height:390}); await p.waitForTimeout(600); await show('rotit → peisaj');
console.log('după rotire, fereastra de așezare încă vizibilă:',await p.evaluate(()=>!document.getElementById('isl-pop').hidden));
// așază decorațiunea: încearcă puncte pe pajiște până se salvează
const before=await p.evaluate(()=>localStorage.getItem('isl_deco')); let placed=false;
for(const [fx,fy] of [[.5,.62],[.45,.7],[.55,.66],[.4,.6],[.6,.6],[.5,.75],[.35,.7],[.65,.7],[.3,.5],[.7,.5],[.5,.45]]){ const xy=await p.evaluate(([fx,fy])=>{ const r=document.querySelector('#isl-stage svg').getBoundingClientRect(); return [r.left+r.width*fx,r.top+r.height*fy]; },[fx,fy]);
  await p.mouse.click(xy[0],xy[1]); await p.waitForTimeout(250); if(await p.evaluate(b=>localStorage.getItem('isl_deco')!==b,before)){ placed=true; break; } }
console.log('decorațiunea s-a așezat după rotire:',placed);
await p.setViewportSize({width:390,height:844}); await p.waitForTimeout(600); await show('rotit înapoi → portret');
await p.evaluate(()=>{ document.getElementById('isl-stage').scrollLeft=200; }); await p.setViewportSize({width:844,height:390}); await p.waitForTimeout(600); await show('derulat, apoi peisaj');
await p.setViewportSize({width:1180,height:820}); await p.waitForTimeout(600); await show('iPad peisaj');
await p.setViewportSize({width:820,height:1180}); await p.waitForTimeout(600); await show('iPad portret');
console.log('erori JS:',errs.length?errs.join(' / '):'niciuna'); await b.close(); })();
