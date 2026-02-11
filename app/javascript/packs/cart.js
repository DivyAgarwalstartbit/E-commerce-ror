document.addEventListener("DOMContentLoaded", function () {
    const formatter = new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "USD"
    });

    function updateCartTotals() {
        let subtotal = 0;
        const cartRows = document.querySelectorAll("tbody tr");

        cartRows.forEach(row => {
            const totalCell = row.querySelector(".cart__total");
            if (totalCell && totalCell.textContent.trim() !== "") {
                const total = parseFloat(
                    totalCell.textContent.replace(/[^\d.-]/g, "")
                );
                if (!isNaN(total)) subtotal += total;
            }
        });

        const subtotalElement = document.getElementById("cart-subtotal");
        const totalElement = document.getElementById("cart-total");

        if (subtotalElement) subtotalElement.textContent = formatter.format(subtotal);
        if (totalElement) totalElement.textContent = formatter.format(subtotal);
    }

    // Quantity change
    document.querySelectorAll(".quantity-input").forEach(input => {
        input.addEventListener("change", function () {
            const lineItemId = this.dataset.lineItemId;
            const price = parseFloat(this.dataset.price);
            const newQuantity = parseInt(this.value, 10);
            const row = this.closest("tr");
            const totalCell = row.querySelector(".cart__total");

            totalCell.textContent = formatter.format(price * newQuantity);
            updateCartTotals();

            const csrfToken = document.querySelector(
                'meta[name="csrf-token"]'
            ).content;

            fetch(`/line_items/${lineItemId}`, {
                method: "PATCH",
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-Token": csrfToken
                },
                body: JSON.stringify({
                    line_item: { quantity: newQuantity }
                })
            });
        });
    });

    // Remove item
    document.querySelectorAll(".remove-cart-btn").forEach(button => {
        button.addEventListener("click", function (e) {
            e.preventDefault();
            if (!confirm("Remove this item from your cart?")) return;

            const lineItemId = this.dataset.lineItemId;
            const row = this.closest("tr");
            const csrfToken = document.querySelector(
                'meta[name="csrf-token"]'
            ).content;

            fetch(`/line_items/${lineItemId}`, {
                method: "DELETE",
                headers: {
                    "X-CSRF-Token": csrfToken
                }
            }).then(response => {
                if (response.ok) {
                    row.remove();
                    updateCartTotals();
                }
            });
        });
    });
});
