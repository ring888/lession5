import { hello } from "../../declarations/hello";

async function post(){

  let post_button = document.getElementById("post");
  let error = document.getElementById("error");
  error.innerText = "";
  post_button.disabled = true;
  let textarea = document.getElementById("message");
  let opt = document.getElementById("opt").value;
  let text = textarea.value;
  try {
    await hello.post(opt,text);
    textarea.value = "";
  } catch (error) {
    console.log(err);
    error.innerText = "Post Failed!";
    
  }
 
  post_button.disabled = false;
}

var num_posts = 0;
async function load_posts(){
  let posts_section = document.getElementById("posts");

  let posts = await hello.posts();
  if(num_posts == posts.length) return;
  posts_section.replaceChildren([]);
  num_posts = posts.length;
  for(var i=0;i<posts.length;i++)
  {
    let post = document.createElement("posts");
    post.innerText = posts[i];
    posts_section.appendChild(post)
  }
}

function load(){
  let post_button = document.getElementById();
  
  post_button.onclick = post;
  load_posts()
}

window.onload = load