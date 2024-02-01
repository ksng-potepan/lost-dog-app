const hamburger = document.querySelector('.hamburger');
const nav = document.querySelector('.nav');
const mask = document.querySelector('.mask');


hamburger.addEventListener('click', (e) => {
  hamburger.classList.toggle('open');
  nav.classList.toggle('open');
  mask.classList.toggle('open');
});

nav.addEventListener('click', (e) => {
  hamburger.classList.remove('open');
  nav.classList.remove('open');
});

mask.addEventListener('click', (e) => {
  hamburger.classList.remove('open');
  nav.classList.remove('open');
  mask.classList.remove('open');
});
