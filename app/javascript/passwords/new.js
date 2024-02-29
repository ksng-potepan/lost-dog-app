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

const eyeConfirmation = document.getElementById('eye-confirmation');

eyeConfirmation.addEventListener('click', () => {
  const passwordField = document.getElementById('password-confirmation');
  passwordField.type = passwordField.type === 'password' ? 'text' : 'password';

  if (eyeConfirmation.classList.contains('fa-eye')) {
    eyeConfirmation.className = 'fa-solid fa-eye-slash';
  } else {
    eyeConfirmation.className = 'fa-solid fa-eye';
  }
});
