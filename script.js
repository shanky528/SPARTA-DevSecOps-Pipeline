function showAlert() {
    const messageDiv = document.getElementById('message');
    messageDiv.innerHTML = "You clicked the button! This static site is deployed via a DevSecOps pipeline.";
    messageDiv.style.animation = "fadeIn 1s ease";
}

// Simple fade-in animation
const style = document.createElement('style');
style.innerHTML = `
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}`;
document.head.appendChild(style);

