---
title: "OpenAI And Language Learning"
date: 2024-09-23T09:55:02+02:00
draft: true
---

# OpenAI And Language Learning

## Introduction

This short article describes how I made a python script based on the OpenAI examples (linkneeded) and the european language levels Common European Framework of Reference (CEFR). https://www.coe.int/en/web/common-european-framework-reference-languages/level-descriptions
At the end of the article I present the prototype python code'

## Motivation
One of the things I've found fustrating while learning a language on my own is the difficulty of finding reading material that is 
 * on my level 
 * interesting to me.

While playing with the aforementioned OpenAI python examples it occured to me that I could try to to use the european language levels (A1 A2 B1 B2 C1 C2) to generate texts in foreign languages at those levels.

Several attempts later. I had a prototype script and prompt that seemed to work reasonably well. I added a bunch of commandline options an defaults and got something halfway decent.

You can give this script the following arguments:
```
-s or --subject eq. -s "History of Florence" Or -s "History" -s "Florence"
-l or --length number of words eq. 500 (default 500)
-L or --language eq. -L italian (default "Italian")
-a or --level  eq -a A1/A2/B1/B2/C1/C2 (default "B1")
-S or --style eq -S formal/informal/cynical etc etc (default="formal")
-f or --format eq -f article/blog/.. (default="article")
-t or --tone Tone of text to generate. neutral, light, somber, humorous, sarcastic etc (default="neutral")

```

I now use this script to generate daily pieces of text in italian an latin to read during my commute to and from work. 

I run it under termux (link needed) on my Android telephone. 

## Results

This script ticks all the following boxes for me.
 * Interesting text to read? Check
 * In a language I'm learning? Check
 * On a level I can manage? Check
 * Usable on a phone? Check
 * During an otherwise boring an nonproductive time? Check


# Running the code

## OpenAI account
To use this with OpenAI, I recommend you get a "pay as you go" account. It is the cheapest way to use OpenAI for personal use. Don't forget to lower the monthly limit from 120 dollars to say 5 dollars. That way you limit the damage from possible runaway programs.

## Setup
Generate an openAI api key and store it in the file .env in the same directory as the python file. 
```
OPEN_AI_KEY="youopenaikeyhere"
```
If you use git, don't forget to add the .env file to the .gitignore file.

## Caveats
When set to the C2 level the results can be rather ..ahem.. poetic!

When generating a piece of text in a language like latin about a modern subject, the result can be anything from hilarious to absurd.
(I haven't dared to try Klingon yet)

## Examples

### A1 language level

./run.py -s "Amsterdam History" -L English -a A1

```
**Amsterdam History**

Amsterdam is the capital city of the Netherlands. It has a very interesting history. The city’s history begins in the 12th century. At this time, Amsterdam was a small fishing village. The people in the village lived by the water. They caught fish and traded them with other places. The name "Amsterdam" comes from a dam on the river Amstel. This dam was built to protect the village from the water.
```
Note the short simple sentences.

### C2 language level

./run.py -s "Amsterdam History" -L English -a C2

```
Amsterdam, the capital city of the Netherlands, boasts a rich and multi-faceted history that dates back to its founding in the late 12th century. Originally established as a modest fishing village along the banks of the Amstel River, the city's name is derived from the word "Amstelredamme," which signifies a dam constructed on the river. This early settlement laid the groundwork for what would become a significant urban center in Europe.
```

Note the longer more complex sentences and extended vocabulary





## python prototype


```
#!/usr/bin/env python3

import argparse
from typing import List
from openai import OpenAI
from dotenv import load_dotenv

# load .env with OPEN_API_KEY
load_dotenv()

# OpenAI init
client = OpenAI()

# Set the prompt
prompt_role = '''
You are a expert in languages.
Your task is to write text
on the SUBJECT,
in the LANGUAGE,
and the european LANGUAGELEVEL that are given to you.
You should respect the instructions:
the LENGTH, the STYLE, The FORMAT and the TONE
'''


def ask_chatgpt(messages):
    response = client.chat.completions.create(model="gpt-4o-mini",
                                              messages=messages)
    return (response.choices[0].message.content)

# populate the prompt with the given arguments
def format_prompt(
        subjects: List[str],
        language: str,
        level: str,
        length_words: int,
        sformat: str,
        style: str,
        tone: str):
    prompt = f"""{prompt_role}\n
    SUBJECT: {subjects}\n
    LANGUAGE: {language}\n
    LANGUAGELEVEL: {level}\n
    FORMAT: {sformat}\n
    TONE: {tone}\n
    LENGTH: {length_words} words\n
    STYLE: {style}"""
    return ask_chatgpt([{"role": "user", "content": prompt}])

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
            "-l",
            "--length",
            type=int, help="Lenght of article in characters",
            default=500)
    parser.add_argument(
            "-L",
            "--language",
            type=str,
            help="Language to generate",
            default="Italian")
    parser.add_argument(
            "-a",
            "--level",
            type=str,
            help="Language level to generate",
            default="B1")
    parser.add_argument(
            "-S",
            "--style",
            type=str,
            help="Style of language to generate. ex formal, informal",
            default="formal")
    parser.add_argument(
            "-f",
            "--format",
            type=str,
            help="Format of text to generate. article, blog etc ",
            default="article")
    parser.add_argument(
            "-t",
            "--tone",
            type=str,
            help="""Tone of text to generate.
            neutral, light, somber, humorous, sarcastic etc""",
            default="neutral")
    requiredNamed = parser.add_argument_group('required named arguments')
    requiredNamed.add_argument(
            "-s",
            "--subject",
            action="append",
            help="Subject/keywords to to write about")

    args = parser.parse_args()

    article = format_prompt(
        args.subject,
        args.language,
        args.level,
        args.length,
        args.format,
        args.style,
        args.tone)
    print(article)
    s = ''.join(str(x) for x in args.subject)
    outfile = open(s + ": " + args.language + " " + args.level + ".md" , 'w+')
    outfile.write(article)
    outfile.close()


if __name__ == "__main__":
    main()
```