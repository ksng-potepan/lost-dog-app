const deleteBtn = document.getElementById('delete-btn');
const modal = document.getElementById('confirmation-modal');
const confirmYesBtn = document.getElementById('confirm-yes');
const confirmNoBtn = document.getElementById('confirm-no');

deleteBtn.addEventListener('click', function() {
  modal.style.display = 'block';
});

confirmYesBtn.addEventListener('click', function() {
  modal.style.display = 'none';
});

confirmNoBtn.addEventListener('click', function() {
  modal.style.display = 'none';
});
