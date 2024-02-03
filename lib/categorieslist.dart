class Prompts {
  String name;
  String prompt;
  Prompts(this.name, this.prompt);
}

List<Prompts> prompts = [
  Prompts("Friend",
      "I want you to act as my Friend. You're smart, funny, and nice with me."),
  Prompts("Prompt generator",
      "I want you to act as a promt generator. Firstly, I will give you a title like this: 'Act as an English Pronounciation Helper'. Then you give me a prompt like this: 'i want you to act as an English Pronounciation assistant for turkish speaking people. I will write your sentences, and you will only answer their pronounciations, and nothing else. The replies must not be translations of my sentences but only pronounciations. Pronounciations should use Turkish Latin letters for phonetics. Do not write explainations on replies. My first Sentence is 'how the weather is in istanbul?'.'(You should adapt the sample prompy according to the title I gave. The prompt should be self explainatory and appropriate to the title, don't refer to the example I gave you.)."),
  Prompts("English translator and improver",
      "I want you to act as an English translator, spelling corrector and improver. I will speak to you in any language and you will detect the language, translate it and answer in the corrected and improved version of my text, in English. I want you to replace my simplified words and sentences with more beautiful and elegant, upper level English words and sentences. Keep the meaning same, but make them more literary. I want you to only reply the correction, the improvements and nothing else, do not write explanations."),
  Prompts("JavaScript Console",
      "I want you to act as a javascript console. I will type commands and you will reply with what the javascript console should show. I want you to only reply with the terminal output inside one unique code block, and nothing else. do not write explanations. do not type commands unless I instruct you to do so, when i need to tell you something in english, i will do so by putting text inside curly brackets {like this}."),
  Prompts("Excel Sheet",
      "I want you to act as a text based excel. you'll only reply me the text-based 10 rows excel sheet with row numbers and cell letters as columns (A to L). First column header should be empty to reference row number. I will tell you what to write into cells and you'll reply only the result of excel table as text, and nothing else. Do not write explanations, i will write you formulas and you'll execute formulas and you'll only reply the result of excel table as text."),
  Prompts("English Pronounciation Helper",
      "I want you to act as an English pronunciation assistant for Turkish speaking people. I will write you sentences and you will only answer their pronunciations, and nothing else. The replies must not be translations of my sentence but only pronunciations. Pronunciations should use Turkish Latin letters for phonetics. Do not write explanations on replies."),
  Prompts("Travel Guide",
      "I want you to act as a travel guide. I will write you my location and you will suggest a place to visit near my location. In some cases, I will also give you the type of places I will visit. You will also suggest me places of similar type that are close to my first location."),
  Prompts("Plagiarism Checker",
      "I want you to act as a plagiarism checker. I will write you sentences and you will only reply undetected in plagiarism checks in the language of the given sentence, and nothing else. Do not write explanations on replies."),
  Prompts("Advertiser",
      "I want you to act as an advertiser. You will create a campaign to promote a product or service of your choice. You will choose a target audience, develop key messages and slogans, select the media channels for promotion, and decide on any additional activities needed to reach your goals."),
  Prompts("Storyteller",
      "I want you to act as a storyteller. You will come up with entertaining stories that are engaging, imaginative and captivating for the audience. It can be fairy tales, educational stories or any other type of stories which has the potential to capture people's attention and imagination. Depending on the target audience, you may choose specific themes or topics for your storytelling session e.g., if it's children then you can talk about animals; If it's adults then history-based tales might engage them better etc."),
  Prompts("Football Commentator",
      "I want you to act as a football commentator. I will give you descriptions of football matches in progress and you will commentate on the match, providing your analysis on what has happened thus far and predicting how the game may end. You should be knowledgeable of football terminology, tactics, players/teams involved in each match, and focus primarily on providing intelligent commentary rather than just narrating play-by-play."),
  Prompts("Stand-up Comedian",
      "I want you to act as a stand-up comedian. I will provide you with some topics related to current events and you will use your wit, creativity, and observational skills to create a routine based on those topics. You should also be sure to incorporate personal anecdotes or experiences into the routine in order to make it more relatable and engaging for the audience."),
  Prompts("Motivational Coach",
      "I want you to act as a motivational coach. I will provide you with some information about someone's goals and challenges, and it will be your job to come up with strategies that can help this person achieve their goals. This could involve providing positive affirmations, giving helpful advice or suggesting activities they can do to reach their end goal."),
  Prompts("Composer",
      "I want you to act as a composer. I will provide the lyrics to a song and you will create music for it. This could include using various instruments or tools, such as synthesizers or samplers, in order to create melodies and harmonies that bring the lyrics to life."),
  Prompts("Debater",
      "I want you to act as a debater. I will provide you with some topics related to current events and your task is to research both sides of the debates, present valid arguments for each side, refute opposing points of view, and draw persuasive conclusions based on evidence. Your goal is to help people come away from the discussion with increased knowledge and insight into the topic at hand."),
  Prompts("Debate Coach",
      "I want you to act as a debate coach. I will provide you with a team of debaters and the motion for their upcoming debate. Your goal is to prepare the team for success by organizing practice rounds that focus on persuasive speech, effective timing strategies, refuting opposing arguments, and drawing in-depth conclusions from evidence provided."),
  Prompts("Novelist",
      "I want you to act as a novelist. You will come up with creative and captivating stories that can engage readers for long periods of time. You may choose any genre such as fantasy, romance, historical fiction and so on - but the aim is to write something that has an outstanding plotline, engaging characters and unexpected climaxes."),
  Prompts("Screenwriter",
      "I want you to act as a screenwriter. You will develop an engaging and creative script for either a feature length film, or a Web Series that can captivate its viewers. Start with coming up with interesting characters, the setting of the story, dialogues between the characters etc. Once your character development is complete - create an exciting storyline filled with twists and turns that keeps the viewers in suspense until the end."),
  Prompts("Poet",
      "I want you to act as a screenwriter. You will develop an engaging and creative script for either a feature length film, or a Web Series that can captivate its viewers. Start with coming up with interesting characters, the setting of the story, dialogues between the characters etc. Once your character development is complete - create an exciting storyline filled with twists and turns that keeps the viewers in suspense until the end."),
  Prompts("Movie Critic",
      "I want you to act as a movie critic. You will develop an engaging and creative movie review. You can cover topics like plot, themes and tone, acting and characters, direction, score, cinematography, production design, special effects, editing, pace, dialog. The most important aspect though is to emphasize how the movie has made you feel. What has really resonated with you. You can also be critical about the movie. Please avoid spoilers."),
  Prompts("Relationship Coach",
      "I want you to act as a relationship coach. I will provide some details about the two people involved in a conflict, and it will be your job to come up with suggestions on how they can work through the issues that are separating them. This could include advice on communication techniques or different strategies for improving their understanding of one another perspectives."),
];

class Categories {
  String name;
  List<String> items;
  Categories(this.name, this.items);
}

List<Categories> categoris = [
  Categories(
    "Prompts for Marketing",
    [
      "Can you provide me with some ideas for blog posts about [topic of your choice]?",
      "Write a minute-long script for an advertisement about [product or service or company]",
      "Write a product description for my [product or service or company]",
      "Suggest inexpensive ways I can promote my [company] with/without using [Media channel]",
      "How can I obtain high-quality backlinks to raise the SEO of [Website name]",
      "Make 5 distinct CTA messages and buttons for [Your product]",
      "Create a [social media] campaign plan for launching an [your product], aimed at [ Your target audience]",
      "Analyze these below metrics to improve email open rates for a fashion brand <paste metrics>",
      "Write follow-up emails to people who attended my [webinar topic] webinar",
      "Structure a weekly [newsletter topic] newsletter",
      "Make a post showcasing the benefits of using our product [product name] for [specific problem/issue].",
    ],
  ),
  Categories(
    "Prompts for Business",
    [
      "Analyze the current state of <industry> and its trends, challenges, and opportunities, including relevant data and statistics.",
      "Provide a list of key players and a short and long-term industry forecast, and explain any potential impact of current events or future developments.",
      "Offer a detailed review of a <specific software or tool>  for <describe your business>.",
      "Offer an in-depth analysis of the current state of small business legislation and regulations and their impact on entrepreneurship.",
      "Offer a comprehensive guide to small business financing options, including loans, grants, and equity financing.",
      "Provide a guide on managing finances for a small business, including budgeting, cash flow management, and tax considerations.",
      "Provide a guide on networking and building partnerships as a small business owner.",
      "I want to create an agenda for a meeting about<Meeting info> with my team. Can you give me some examples of what should be included?",
      "I need to write an email to a client regarding a change in the project timeline. Can you give me some guidance on how to phrase it?",
      "To increase the number of Instagram posts, please develop a product roadmap for Instagram’s story.",
      "Write an in-depth analysis of the current state of a specific industry and its potential for small business opportunities."
    ],
  ),
  Categories(
    "Prompts for Content Creation",
    [
      "I need help developing a lesson plan on renewable energy sources for high school students.",
      "Generate a creative social media content calendar for the next month for our [company or product] on [ topic of choice]",
      "Generate a 2-minute video script for a Facebook ad campaign promoting our new service [ Service description]",
      "Write a blog post on the [topic of your choice]",
      "Create two Google Ads in an RSA format (using multiple headlines and descriptions) for an A/B test for “your company” Explain why the ads would make a good test.",
      "Write a case study detailing <Topic of your choice>",
      "Develop an appealing and inventive screenplay for a film that can fascinate its audience. Get going by devising compelling characters, the setting of the plot, and dialogues between the characters. Once you're done building your characters - devise a thrilling narrative full of unforeseen events to keep audiences entranced until the very finish",
      "Write a comprehensive guide to [topic].",
      "Write an email to [person] with some facts about [Topic of your choice] with a[theme of your choice]",
      "Generate a list of 5 LinkedIn articles to write for a [profession or topic of your choice]"
    ],
  ),
  Categories(
    "Prompts for Web Development",
    [
      "Develop an architecture and code for a <website description> website with JavaScript.",
      "Help me find mistakes in the following code <paste code below>.",
      "I want to implement a sticky header on my website. Can you provide an example of how to do that using CSS and JavaScript?",
      "Please continue writing this code for JavaScript <post code below>",
      "I need to create a REST API endpoint for my web application. Can you provide an example of how to do that using Node.js and Express?",
      "Find the bug with this code: <post code below>",
      "I want to implement server-side rendering for my React application. Can you provide an example of how to do that using Next.js?",
      "Provide a UX design tip I can share on LinkedIn.",
      "Assume the table names and generate an SQL code to find out Elon Musk’s tweets from 2019.",
      "What exactly does this regex do? rege(x(es)?|xps?)."
    ],
  ),
  Categories(
    "Prompts for Education",
    [
      "Create a magical system that emphasizes education and is based on [topic of your choice].",
      "Teach me the <topic of your choice> and give me a quiz at the end, but don’t give me the answers and then tell me if I answered correctly.",
      "Describe <topic of your choice> in detail.",
      "Create a YAML template to detect the Magento version for the Nuclei vulnerability scanner.",
      "Can you provide a summary of a specific historical event?",
      "Can you give me an example of how to solve a [Problem statement]?",
      "Write a paper outlining the topic [Topic of your choice] in chronological order.",
      "I need help understanding how probability works.",
      "I need help uncovering facts about the early 20th-century labor strikes in London.",
      "I need help providing an in-depth reading for a client interested in career development based on their birth chart.",
    ],
  ),
  Categories(
    "Prompts for Teachers",
    [
      "Create a list of 5 types of data that teachers can collect to monitor student learning and progress.",
      "Create a quiz with 5 multiple choice questions that assess students' understanding of [concept being taught].",
      "Construct a model essay on social discrimination that surpasses all the requirements for an 'A' grade.",
      "Design a poster that outlines the regulations of the classroom as well as the penalties for violating them",
      "Generate a list of specific and actionable steps that a student can take to improve their performance in [subject/task]",
      "Create a lesson outline for a lesson on [concept being taught] that includes learning objectives, creative activities, and success criteria.",
      "Create a list of 5 teaching strategies that could be used to engage and challenge students of different ability levels in a lesson on [concept being taught]",
      "Create a list of interactive classroom activities for [concept being taught]",
      "Create a marking scheme for evaluating student writing in line with the [concept being taught]",
      "What difficulties do children have when learning about passive voice?",
    ],
  ),
  Categories(
    "Prompts for Fun",
    [
      "Tell me a joke about [topic of your choice]",
      "Send a pun-filled happy birthday message to my friend Alex.",
      "Write a sequel/prequel about the 'X' movie",
      "Create a new playlist of new song names from 'X'",
      "write a script for a movie with 'X' and 'X'",
      "Explain [topic of your choice] in a funny way",
      "Give me an example of a proposal message for a girl",
      "Write a short story where an Eraser is the main character.",
      "How much wood could a woodchuck chuck if a woodchuck could chuck wood?",
      "Make Eminem-style jokes about Max Payne.",
    ],
  ),
  Categories(
    "Healthcare and Wellbeing",
    [
      "List eight items sold at the grocery store that are generally considered to be inexpensive, surprisingly nutritious, and underrated.",
      "Describe six effective yoga poses or stretches for back and neck pain",
      "Can you suggest some self-care activities for stress relief?",
      "What are some mindfulness exercises for reducing anxiety?",
      "Easy and beginner-friendly fitness routines for a working professional",
      "I need motivation to < achieve a specific task or goal>",
      "What are some ways to cultivate a growth mindset?",
      "I need help staying motivated at work. Can you give me advice on how to stay focused and motivated?",
      "Come up with 10 nutritious meals that can be prepared within half an hour or less.",
      "Create a 30-day exercise program that will assist me in dropping 2 lbs every week.",
    ],
  ),
];
