const formProtect = document.getElementById("form_protect");
const firstNext = document.getElementById("first-next");
const secondNext = document.getElementById("second-next");
const firstBack = document.getElementById("first-back");
const secondBack = document.getElementById("second-back");

firstNext.addEventListener("click", function() {
  formProtect.style.marginLeft = "-100%";
});

secondNext.addEventListener("click", function() {
  formProtect.style.marginLeft = "-200%";
});

firstBack.addEventListener("click", function() {
  formProtect.style.marginLeft = "0";
});

secondBack.addEventListener("click", function() {
  formProtect.style.marginLeft = "-100%";
});
