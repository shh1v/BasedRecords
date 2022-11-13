<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Based Records</title>
    <!-- Stylesheet -->
    <link rel="stylesheet" href="styles.css" />
    <!-- Font links -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700;900&display=swap"
      rel="stylesheet"
    />
  </head>
  <!-------------------------------->
  <!-- HEADER (Logo & Navigation) -->
  <!-------------------------------->
  <body>
    <div class="header">
      <div class="navbar">
        <div class="logo">
          <a href="index.html">
            <img src="Assets/Based Records Logo.png" width="400px" />
          </a>
        </div>
        <nav>
          <ul>
            <li><a href="index.html">Home</a></li>
            <li><a href="#records">Shop</a></li>
            <li><a href="orders.html">Orders</a></li>
            <li><a href="account.html">Account</a></li>
          </ul>
        </nav>
        <a href="cart.html">
          <img src="Assets/shopping-cart.png" width="40px" height="40px" />
        </a>
      </div>
    </div>

    <!---------------->
    <!-- SEARCH BAR -->
    <!---------------->
    <div class="search">
      <form action="" class="search-bar">
        <input type="text" placeholder="Search our records" name="q" />
        <button type="submit"><img src="Assets/search-icon.png" /></button>
      </form>
    </div>

    <!------------>
    <!-- FILTER -->
    <!------------>

    <div class="filter">
      <h1>Filter by genre:</h1>
      <select name="genre" id="genre">
        <option value="indie-alternative">Indie/Alternative</option>
        <option value="heavy-metal">Heavy Metal</option>
        <option value="rap">Rap</option>
        <option value="pop-rock">Pop Rock</option>
        <option value="uk-garage">UK Garage</option>
        <option value="hip-hop">Hip Hop</option>
        <option value="pop">Pop</option>
        <option value="rock">Rock</option>
        <option value="rnb-soul">R&B/Soul</option>
        <option value="reggae">Reggae</option>
      </select>
    </div>
    <!--------------------->
    <!-- PRODUCTS (Shop) -->
    <!--------------------->
    <!-- Listing all the products from the database-->
    
    <div class="products">
      <table id="records">
        <!-- Header values -->
        <tr>
          <th>Record Name</th>
          <th>Artist</th>
          <th>Genre</th>
          <th>Price</th>
        </tr>
        <!-- Begin records -->
        <tr>
          <td>Currents</td>
          <td>Tame Impala</td>
          <td>Indie/Alternative</td>
          <td>$34.99</td>
        </tr>
        <tr>
          <td>Lonerism</td>
          <td>Tame Impala</td>
          <td>Indie/Alternative</td>
          <td>$29.99</td>
        </tr>
        <tr>
          <td>good kid, m.A.A.d city</td>
          <td>Kendrick Lamar</td>
          <td>Rap</td>
          <td>$39.99</td>
        </tr>
        <tr>
          <td>Meliora</td>
          <td>Ghost</td>
          <td>Heavy Metal</td>
          <td>$49.99</td>
        </tr>
        <tr>
          <td>Salad Days</td>
          <td>Mac DeMarco</td>
          <td>Indie/Alternative</td>
          <td>$44.99</td>
        </tr>
        <tr>
          <td>Punisher</td>
          <td>Phoebe Bridgers</td>
          <td>Indie/Alternative</td>
          <td>$44.99</td>
        </tr>
        <tr>
          <td>Abbey Road</td>
          <td>The Beatles</td>
          <td>Pop Rock</td>
          <td>$39.99</td>
        </tr>
        <tr>
          <td>Untrue</td>
          <td>Burial</td>
          <td>UK Garage</td>
          <td>$29.99</td>
        </tr>
        <tr>
          <td>Plastic Beach</td>
          <td>Gorillaz</td>
          <td>Hip Hop</td>
          <td>$39.99</td>
        </tr>
        <tr>
          <td>Demon Days</td>
          <td>Gorillaz</td>
          <td>Hip Hop</td>
          <td>$34.99</td>
        </tr>
        <tr>
          <td>Thriller</td>
          <td>Michael Jackson</td>
          <td>Pop</td>
          <td>$34.99</td>
        </tr>
        <tr>
          <td>The Dark Side of the Moon</td>
          <td>Pink Floyd</td>
          <td>Rock</td>
          <td>$29.99</td>
        </tr>
        <tr>
          <td>Apollo XXI</td>
          <td>Steve Lacy</td>
          <td>R&B/Soul</td>
          <td>$24.99</td>
        </tr>
        <tr>
          <td>Legend</td>
          <td>Bob Marley</td>
          <td>Reggae</td>
          <td>$39.99</td>
        </tr>
      </table>
    </div>
  </body>
</html>
