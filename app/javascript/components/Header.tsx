import React from 'react';
import { Link } from 'react-router-dom';

interface HeaderProps {
    title: string;
}

export default function Header({ title}: HeaderProps) {
    return (
        <header>
            <h1>{title}</h1>
        </header>
    );
}