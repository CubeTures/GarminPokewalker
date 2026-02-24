# Writeup

Since the making of the app was such a chore, I've decided to document my journey here for posterity's sake. If you're just wanting to install this app or even if you're just contributing, you don't need to read this. However, if you want to make an app of a similar scale to this, then you might want to read this so you can potentially learn from my journey.

## Vision

This app came into fruition for very simplistic reasons: I just wanted to make it. I was expecting making an app for a watch to have typical embedded systems restrictions in regards to memory and compute, but what I wasn't prepared for was how much of a headache GarminOS and Monkey C would create themselves. By nature they are restrictive, but that doesn't change the fact they cause a lot of problems for seemingly trivial aspects of development. As they say: "The road to hell is paved with good intentions."

My initial vision of this app was one that played exactly like the original Pokewalker but with greater combat and an offline-first approach. Meaning: 1. it should be a standalone game (and not need to connect to any other outside app), and by proxy 2. it should not use API calls for its main functionality. With this in mind, I began to research what the limitations for such an app would entail.

I quickly came to realize that this app would never see the Garmin Connect IQ Store due to copyright, so that helped me reduce my scope to something more realistic: just making it for myself. This meant that the app only needed to work on my watch (Instinct 3 Solar 45mm). But, that also meant that I wouldn't gain the benefit of special APIs not available on my watch. It was a potentially double edged sword, but considering my watch was supposed to be on the 5.1.0 API (the second most recent API), I was optimistic.

So, following that and an extensive reading of the documentation for Monkey C, I began developing my watch.

## Development Environment

The first obstacle unexpectedly came in the form of the development environment. As a Linux user, I realized very quickly there were problems with the SDK: it relied on a now unsupported library `libwebkit2gtk-4.0`. Installing it was not a huge hurdle, but as someone fresh out of research and ready to begin coding an app, I was not expecting to spend so much time merely installing the tools.

I'll skip the details, but essentially I had to register the Ubuntu Jammy repository as a target for my package manager (`/etc/apt/sources.list.d/jammy-webkit.sources`), then pin it (`etc/apt/preferences.d/jammy-pin`), and finally install the library so the SDK manager could run.

After installing the necessary items from the manager, I went through the relatively harmless process of installing the VSCode extension and creating a project therein. With that out of the way, I of course immediately turned on the strictest typechecking for the project. Little did I know that would be the next big headache I faced.

## Typechecking

I don't like dynamically typed programming languages, and everyone that knows me knows this fact. The onus should be on the compiler -- not the programmer -- to verify the types and catch simple mistakes ahead of time. As a result, I usually go out of my way to make dynamic languages as strict as possible: using TypeScript instead of JavaScript, setting Pylance to strict mode for Python, and now, setting the Monkey to strict for Monkey C. These always come with some sort of inconvenience you need to account for, but the safety they provide and the time they save you from debugging is always worth the effort of maintaining type safe code. Monkey C really made me rethink this though.

When you're working with such a niche language that is proprietary, documentation is everything. So when the documentation doesn't state something exists, you simply have no way of knowing it exists. Such is the case for the elusive `:typecheck(disableBackgroundCheck)`. Search on GitHub for it, and it's pretty apparent it exists. But, as someone who is new to the language and confronted with the cryptic error `Value 'ABC' not available in all function scopes.`, I was lost more you could believe. Absolutely nowhere in the documentation -- at least nowhere I thought to check -- does it list that this exists. In fact, only after scrolling the forums for an embarrassingly long time did I finally find one lone sole reference it. I knew at that moment what I was going to be dealing with: poor documentation, unsolvable answers, and hours of scrolling forums.

To this very day, I only know of four possible flags for the `:typecheck` annotation:

```mc
(:typecheck(false))
(:typecheck(true))
(:typecheck(disableGlanceCheck))
(:typecheck(disableBackgroundCheck))
```

I wish there was one for disabling initialized checks, but alas there is none I could find -- emphasis on the word find. Hence, you may notice my codebase's models have a healthy slathering of `(:initialized)` annotations in them, as there wasn't a great alternative. With a newfound wake up call, I knew making the next part of this project was going to be potentially the most gruesome.

## Resources

Resources are perhaps the most limiting facet of Monkey C, particularly when it comes to creating a project as resource intensive as mine. Just for sprites alone I knew I would have at least 800. I could do some tricks to help me reduce their size, but there was no getting around the fact that I needed to be careful about how I loaded the bitmaps themselves into RAM.

# Notes

- Changing the color
    - Pure black and white
    - Artistic rendering based on restriction

- No dynamic loading
    - Must have a reference to each resource at build time
- Resources have overhead
    - 800 resources takes up a lot of RAM, even if never referenced
- No efficient file format
    - No line by line loading
    - JSON takes up a huge amount of space
    - Cannot encode in RLE
- Bitmaps compress very well
    - Make sprite sheets to limit resource overhead
- No line-by-line loading
    - Data needs to be chunked into strings and decompressed using ByteArray

- No drawBitmap2
    - Only realized after crafting the perfect system
    - Need to store double the sprites just to reflect them
