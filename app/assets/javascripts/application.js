// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

function toggleDetails(button) {
  var detailsTable = button.parentNode.parentNode.nextElementSibling.querySelector(".details-table");
  detailsTable.classList.toggle("hidden");
  button.innerText = detailsTable.classList.contains("hidden") ? "Afficher détails" : "Masquer détails";
}
