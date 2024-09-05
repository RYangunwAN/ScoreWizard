// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getFirestore, collection, onSnapshot } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js";

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyBQnubk7dlL9b4uO9WQ1NyNsslDn9VhfPI",
    authDomain: "scorewizard-3d1e9.firebaseapp.com",
    projectId: "scorewizard-3d1e9",
    storageBucket: "scorewizard-3d1e9.appspot.com",
    messagingSenderId: "90632323398",
    appId: "1:90632323398:web:cb283f6b081431e206a547"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

let teamLogos = new Map();
teamLogos.set('DRivals', 'assets/logo/DRivals.png');
teamLogos.set('AFG', 'assets/logo/AFG.png');
teamLogos.set('None', 'assets/logo/gigachad.png');

function updateContentWithAnimation(elementId, newValue) {
    const element = document.getElementById(elementId);
    
    element.classList.add('fade-out');

    element.addEventListener('animationend', function handler() {
        element.classList.remove('fade-out');
        if (elementId != "")
        element.textContent = newValue; 
        element.classList.add('fade-in');

        element.addEventListener('animationend', function handler() {
            element.classList.remove('fade-in');
            element.removeEventListener('animationend', handler);
        });
        
        element.removeEventListener('animationend', handler);
    });
}

function listenForData() {
    const query = collection(db, "matches");

    onSnapshot(query, (querySnapshot) => {
        querySnapshot.forEach((doc) => {
            const data = doc.data();
            console.log(data);

            let stage = data.stage.toUpperCase();
            let p1Name = data.player1Name.toUpperCase();
            let p2Name = data.player2Name.toUpperCase();

            const p1TeamNameElement = document.getElementById("p1TeamNameStack");
            const p1NameElement = document.getElementById("p1NameStack");
            const p1ScoreElement = document.getElementById("p1ScoreStack");
            const stageElement = document.getElementById("stageStack");
            const p2NameElement = document.getElementById("p2NameStack");
            const p2TeamNameElement = document.getElementById("p2TeamNameStack");
            const p2ScoreElement = document.getElementById("p2ScoreStack");


            if (p1TeamNameElement.textContent !== data.player1TeamLogo) {
                updateContentWithAnimation("p1TeamNameStack", data.player1TeamLogo);
            }

            console.log(p1Name);
            console.log(p1NameElement.textContent);
            if (p1NameElement.textContent !== p1Name) {
                updateContentWithAnimation("p1NameStack", p1Name);
            }

            console.log(p1ScoreElement.textContent);
            console.log(data.player1Score);
            if (p1ScoreElement.textContent != data.player1Score) {
                updateContentWithAnimation("p1ScoreStack", data.player1Score);
            } else if (p1ScoreElement.textContent.trim() === "") {
                updateContentWithAnimation("p1ScoreStack", 0);
            }

            if (stageElement.textContent !== stage) {
                updateContentWithAnimation("stageStack", stage);
            }

            if (p2NameElement.textContent !== p2Name) {
                updateContentWithAnimation("p2NameStack", p2Name);
            }

            if (p2TeamNameElement.textContent !== data.player2TeamLogo) {
                updateContentWithAnimation("p2TeamNameStack", data.player2TeamLogo);
            }

            if (p2ScoreElement.textContent != data.player2Score) {
                updateContentWithAnimation("p2ScoreStack", data.player2Score);
            } else if (p2ScoreElement.textContent.trim() === "") {
                updateContentWithAnimation("p2ScoreStack", 0);
            }

            const p1TeamImg = document.getElementById("p1TeamStack");
            const p2TeamImg = document.getElementById("p2TeamStack");

            const p1ImgSrc = document.getElementById("p1TeamStack").getAttribute("src");
            const p2ImgSrc = document.getElementById("p2TeamStack").getAttribute("src");

            if (p1ImgSrc !== teamLogos.get(data.player1TeamLogo)) {
                updateImageWithAnimation(p1TeamImg, getImagePath(data.player1TeamLogo));
            }

            if (p2ImgSrc !== teamLogos.get(data.player2TeamLogo)) {
                updateImageWithAnimation(p2TeamImg, getImagePath(data.player2TeamLogo));
            }
        });
    }, (error) => {
        console.error("Error fetching real-time data: ", error);
    });
}

function updateImageWithAnimation(element, newSrc) {
    element.classList.add('fade-out');

    // Wait for the fade-out animation to complete before updating src
    element.addEventListener('animationend', function handler() {
        element.classList.remove('fade-out');
        element.src = newSrc;
        element.classList.add('fade-in');

        // Remove the fade-in class after animation completes
        element.addEventListener('animationend', function handler() {
            element.classList.remove('fade-in');
            element.removeEventListener('animationend', handler);
        });

        element.removeEventListener('animationend', handler);
    });
}

function getImagePath(team) {
    return teamLogos.get(team) ?? teamLogos.get('None');
}

listenForData();
