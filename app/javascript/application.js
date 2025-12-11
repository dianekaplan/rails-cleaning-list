// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// Auto-dismiss flash messages after 3 seconds
document.addEventListener('DOMContentLoaded', () => {
  const flashMessages = document.querySelectorAll('.flash');

  flashMessages.forEach((flash) => {
    setTimeout(() => {
      flash.style.transition = 'opacity 0.5s ease-out';
      flash.style.opacity = '0';

      setTimeout(() => {
        flash.remove();
      }, 500);
    }, 3000);
  });
});
