import React from "react";
import Header from "../components/Header";
import Searchbar from "../components/Searchbar";
import BookCard from "../components/BookCard";

export default function Dashboard(){
  return (
    <div>
      <Header title="Seattle Library" />
      <Searchbar />
      <BookCard />
    </div>
  )
}