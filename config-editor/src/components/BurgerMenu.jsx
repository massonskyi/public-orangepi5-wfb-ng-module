import React, { useState } from 'react';
import { CSSTransition } from 'react-transition-group';
import '../styles/BurgerMenu.css'; // Ensure the path is correct

function BurgerMenu() {
    const [isMenuOpen, setIsMenuOpen] = useState(false);

    const toggleMenu = () => {
        setIsMenuOpen(!isMenuOpen); // Toggle between open and close
    };

    return (
        <div className="burger-menu-container">
            <CSSTransition
                in={isMenuOpen}
                timeout={300}
                classNames="menu-transition"
                unmountOnExit
            >
                <div className="menu">
                    <button className="burger-button" onClick={toggleMenu}>
                        {isMenuOpen ? '✖' : '☰'}
                    </button>
                    <ul>
                        <li><a href="#config-editor" onClick={toggleMenu}>Config Editor</a></li>
                        <li><a href="#recent-addresses" onClick={toggleMenu}>Recent Addresses</a></li>
                        <li><a href="#some-other-section" onClick={toggleMenu}>Some Other Section</a></li>
                    </ul>
                </div>
            </CSSTransition>

            {!isMenuOpen && (
                <button className="burger-button" onClick={toggleMenu}>
                    ☰
                </button>
            )}
        </div>
    );
}

export default BurgerMenu;
