const formAmble = document.getElementById("form_amble");
const formNext = document.getElementById("form_next");
const back = document.getElementById("back");

formNext.addEventListener("click", function() {
  formAmble.style.marginLeft = "-100%";
});

back.addEventListener("click", function() {
  formAmble.style.marginLeft = "0";
});
