let currentUser = null;
let currentCategory = "all";
let stealth = false;

// 🎮 GAME LIST (EDIT / ADD ALL 100+ HERE)
const games = [
  {file:"cl2048.html", name:"2048", cat:"puzzle"},
  {file:"clrun3.html", name:"Run 3", cat:"action"},
  {file:"clamongus.html", name:"Among Us", cat:"multi"}
];

// 🔐 AUTH
function signup() {
  auth.createUserWithEmailAndPassword(email.value, password.value)
    .catch(e => msg.innerText = e.message);
}

function login() {
  auth.signInWithEmailAndPassword(email.value, password.value)
    .catch(e => msg.innerText = e.message);
}

auth.onAuthStateChanged(user => {
  if (user) {
    currentUser = user;
    authDiv(false);
    loadUser();
  }
});

function authDiv(show) {
  document.getElementById("auth").style.display = show ? "flex" : "none";
  document.getElementById("app").style.display = show ? "none" : "block";
}

// 🧠 USER DATA
function loadUser() {
  db.collection("users").doc(currentUser.uid).get().then(doc => {
    if (!doc.exists) {
      db.collection("users").doc(currentUser.uid).set({
        dark:false,
        stealth:false,
        achievements:[]
      });
    }
    renderGames();
  });
}

// 🎨 UI
function toggleDark() {
  document.body.classList.toggle("dark");
}

function toggleStealth() {
  stealth = !stealth;
  renderGames();
}

function panic() {
  window.location.href = "https://classroom.google.com";
}

function setCategory(c) {
  currentCategory = c;
  renderGames();
}

// 🎮 RENDER GAMES
function renderGames() {
  const q = search.value.toLowerCase();
  const box = document.getElementById("games");
  box.innerHTML = "";

  games
    .filter(g => (currentCategory==="all" || g.cat===currentCategory))
    .filter(g => g.name.toLowerCase().includes(q))
    .forEach(g => {
      box.innerHTML += `
        <div class="card">
          <h3>${stealth ? "Math Activity" : g.name}</h3>
          <iframe src="games/${g.file}" loading="lazy"></iframe>
        </div>`;
    });
}
