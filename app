<!doctype html>
<html lang="ar">   
 <head>   
  <meta charset="UTF-8">   
  <title>💼 نظام فواتيرك الكرتوني 💼</title>   
  <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>   
  <style>  
    body {  
      font-family: 'Cairo', sans-serif;  
      direction: rtl;  
      margin: 0;  
      padding: 10px;  
      background-color: #fefefe;  
      color: #333;  
      overflow-x: hidden;  
    }  
    .dark-mode {  
      background-color: #1e1e1e;  
      color: #eee;  
    }  
    .container {  
      max-width: 1000px;  
      margin: auto;  
      text-align: center;  
    }  
    h1 {  
      font-size: 26px;  
      margin: 10px 0;  
    }  
    .controls, .form-group, .table-controls {  
      display: flex;  
      justify-content: center;  
      flex-wrap: wrap;  
      gap: 10px;  
      margin-bottom: 10px;  
    }  
    input, button {  
      padding: 8px 10px;  
      font-size: 14px;  
      border-radius: 8px;  
      border: 1px solid #aaa;  
    }  
    button {  
      background-color: #a366f4;  
      color: white;  
      cursor: pointer;  
    }  
    button:hover {  
      background-color: #7a3de3;  
    }  
    table {  
      width: 100%;  
      border-collapse: collapse;  
      margin-top: 10px;  
    }  
    th, td {  
      border: 1px solid #ccc;  
      padding: 8px;  
      font-size: 14px;  
    }  
    #totalBox {  
      background-color: #d4f7d4;  
      margin: 10px auto;  
      padding: 8px 12px;  
      border-radius: 10px;  
      display: inline-block;  
      font-weight: bold;  
      color: #155724;  
    }  
    .footer {  
      margin-top: 20px;  
      font-size: 13px;  
      opacity: 0.5;  
    }  
    .hidden { display: none; }  
    .company-frame, .sort-frame {  
      border: 2px dashed #aaa;  
      padding: 10px;  
      border-radius: 12px;  
      margin: 10px auto;  
      display: inline-block;  
      background-color: #f9f9f9;  
    }  
    .dark-mode .company-frame, .dark-mode .sort-frame {  
      background-color: #2a2a2a;  
      border-color: #555;  
    }  
    #msg {  
      color: #28a745;  
      font-weight: bold;  
      margin: 10px;  
      font-size: 16px;  
      opacity: 0;  
      transition: opacity 0.5s;  
    }  
  </style>   
 </head>   
 <body>   
  <div class="container">   
   <h1>💼 نظام فواتيرك الكرتوني 💼</h1>  
   <div class="controls"> <button onclick="toggleDarkMode()">🌗 الوضع الليلي/النهاري</button> <button onclick="toggleSimpleMode()">🪄 Simple Mode</button> <button onclick="sortByName()">🔤 ترتيب بالاسم</button> <button onclick="sortByPriceDesc()">💰 ترتيب بالسعر</button>   
   </div>   
   <div class="sort-frame"> <button onclick="manualSort()">📌 ترتيب يدوي</button> <button onclick="disableSort()">🚫 إيقاف الترتيب اليدوي</button>   
   </div>   
   <div class="company-frame">   
    <div class="form-group">   
     <input type="text" id="companyName" placeholder="🏢 اسم الشركة"> <button onclick="saveCompanyName()">💾 حفظ اسم الشركة</button> <button onclick="editCompanyName()">✏️ تعديل الاسم</button>   
    </div>   
   </div>   
   <div class="form-group">   
    <input type="text" id="productName" placeholder="📦 اسم المنتج">   
    <input type="number" id="productPrice" placeholder="💵 السعر"> <button onclick="addProduct()">➕ أضف المنتج</button> <button onclick="saveData()">📂 حفظ البيانات</button>   
   </div>   
   <div class="form-group">   
    <input type="text" id="searchInput" onkeyup="searchProduct()" placeholder="🔍 ابحث عن المنتج...">   
   </div>   
   <table id="productTable">   
    <thead>   
     <tr>   
      <th>🏢 الشركة</th>   
      <th>📦 المنتج</th>   
      <th>💵 السعر</th>   
      <th>✏️ تعديل</th>   
      <th>🗑️ حذف</th>   
     </tr>   
    </thead>   
    <tbody></tbody>   
   </table>   
   <div id="totalBox">  
    📊 الإجمالي: 0 جنيه  
   </div>   
   <br> <button onclick="calculateTotal()">🧮 احسب التكلفة</button>   
   <div id="msg">  
    ✔️ تمام يا ريس  
   </div>   
   <div class="footer">  
    Youssefabdelhamed  
   </div>  
  </div>   
  <script>  
    let products = [];  
    let simpleMode = false;  
    let totalCalculations = 0;  
    let sortableInstance;

    window.onload = () => {  
      const saved = localStorage.getItem('invoiceData');  
      const company = localStorage.getItem('companyName');  
      if (saved) products = JSON.parse(saved);  
      if (company) document.getElementById('companyName').value = company;  
      rebuildTable();  
    }  

    function toggleDarkMode() {  
      document.body.classList.toggle('dark-mode');  
    }  

    function toggleSimpleMode() {  
      simpleMode = !simpleMode;  
      document.querySelectorAll('.controls button').forEach((btn, i) => {  
        if (!['🌗 الوضع الليلي/النهاري','🪄 Simple Mode'].includes(btn.innerText)) {  
          btn.style.display = simpleMode ? 'none' : 'inline-block';  
        }  
      });  
      document.querySelectorAll('.form-group')[0].style.display = simpleMode ? 'none' : 'flex';  
      document.getElementById('searchInput').parentElement.style.display = 'flex';  
    }  

    function saveCompanyName() {  
      const company = document.getElementById('companyName').value;  
      localStorage.setItem('companyName', company);  
      alert('✔️ تم حفظ اسم الشركة');  
    }  

    function editCompanyName() {  
      document.getElementById('companyName').focus();  
    }  

    function addProduct() {  
      const name = document.getElementById('productName').value;  
      const price = parseFloat(document.getElementById('productPrice').value);  
      const company = document.getElementById('companyName').value;  
      if (!name || isNaN(price)) return alert('❌ أدخل بيانات صحيحة');  
      products.push({ name, price, company });  
      rebuildTable();  
      saveData();  
      document.getElementById('productName').value = '';  
      document.getElementById('productPrice').value = '';  
      showMessage();  
    }  

    function showMessage() {  
      const msg = document.getElementById('msg');  
      msg.style.opacity = 1;  
      setTimeout(() => { msg.style.opacity = 0; }, 5000);  
    }  

    function rebuildTable() {  
      const tbody = document.querySelector('#productTable tbody');  
      tbody.innerHTML = '';  
      products.forEach((p, i) => {  
        const row = document.createElement('tr');  
        row.innerHTML = `  
          <td>${p.company}</td>  
          <td>${p.name}</td>  
          <td>${p.price.toFixed(2)}</td>  
          <td><button onclick="editProduct(${i})">✏️</button></td>  
          <td><button onclick="deleteProduct(${i})">🗑️</button></td>  
        `;  
        tbody.appendChild(row);  
      });  
      calculateTotal(false);  
    }  

    function editProduct(i) {  
      const name = prompt('اسم جديد:', products[i].name);  
      const price = parseFloat(prompt('السعر الجديد:', products[i].price));  
      if (!name || isNaN(price)) return;  
      products[i].name = name;  
      products[i].price = price;  
      rebuildTable();  
      saveData();  
    }  

    function deleteProduct(i) {  
      products.splice(i, 1);  
      rebuildTable();  
      saveData();  
    }  

    function calculateTotal(auto = true) {  
      const total = products.reduce((sum, p) => sum + p.price, 0);  
      document.getElementById('totalBox').innerText = `📊 الإجمالي: ${total.toFixed(2)} جنيه | رقم ${++totalCalculations}`;  
      if (auto) setTimeout(() => document.getElementById('totalBox').innerText = '', 30000);  
    }  

    function sortByName() {  
      products.sort((a, b) => a.name.localeCompare(b.name));  
      rebuildTable();  
    }  

    function sortByPriceDesc() {  
      products.sort((a, b) => b.price - a.price);  
      rebuildTable();  
    }  

    function manualSort() {  
      const tbody = document.querySelector("#productTable tbody");  
      sortableInstance = new Sortable(tbody, {  
        animation: 150,  
        onEnd: () => {  
          const newOrder = [];  
          tbody.querySelectorAll("tr").forEach(row => {  
            const company = row.children[0].innerText;  
            const name = row.children[1].innerText;  
            const price = parseFloat(row.children[2].innerText);  
            newOrder.push({ name, price, company });  
          });  
          products = newOrder;  
          saveData();  
        }  
      });  
      alert("📌 يمكنك الآن سحب المنتجات بالترتيب الذي تريده.");  
    }  

    function disableSort() {  
      if (sortableInstance) sortableInstance.destroy();  
      alert("🛑 تم إيقاف الترتيب اليدوي.");  
    }  

    function searchProduct() {  
      const term = document.getElementById('searchInput').value.toLowerCase();  
      document.querySelectorAll('#productTable tbody tr').forEach(row => {  
        const txt = row.children[1].innerText.toLowerCase();  
        row.style.display = txt.includes(term) ? '' : 'none';  
      });  
    }  

    function saveData() {  
      localStorage.setItem('invoiceData', JSON.stringify(products));  
    }
  </script>   
 </body>  
</html>
