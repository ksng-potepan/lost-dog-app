const eye = document.getElementById('eye');

eye.addEventListener('click', () => {
  const passwordField = document.getElementById('password');
  passwordField.type = passwordField.type === 'password' ? 'text' : 'password';

  if (eye.classList.contains('fa-eye')) {
    eye.className = 'fa-solid fa-eye-slash';
  } else {
    eye.className = 'fa-solid fa-eye';
  }
});
