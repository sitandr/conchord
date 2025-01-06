#import "../lib.typ": new-chordgen, overchord, chordlib, chordify, change-tonality, sized-chordlib, change-tonality

#let chord = new-chordgen(string-number: auto)

// For better png in README
#set page(height: auto, margin: (right: 0%))

#show: chordify

#h(1fr)#box[
    #set align(center)
    // Song name
    = Zombie
    // Band
    == The Cranberries
]#h(5fr)

#place(right, dx: -1em, {
    set align(left)
    // Make all text in chord graph bold
    show text: strong
    // List of used chords there
    sized-chordlib(heading-level: 2, width: 100pt, switch: (D: 3), at: (A: 5))
})


=== #raw("[[Verse 1]]")

[Em] Another [C] head hangs lowly \
[G]  Child is slowly [D] taken \
[Em] And the violence [C] caused such silence \
[G]  Who are we [D] mistaken?


=== #raw("[[Pre-Chorus]]")

[Em] But you see, it's not me, it's not [C] my family \
[G]  In your head, in your head they are [D] fightin' \
[Em] With their tanks and their bombs [C] and their bombs and their guns \
[G]  In your head, in your head they are [D] cryin'

=== #raw("[[Chorus]]")
#change-tonality(2)
// Raw works too, no manual breaks needed!
#show raw.where(block: true): set text(font: "Libertinus Serif", size: 1.25em)
```
[Em] In your head, [C] in your head
[G ] Zombie, zombie, [D] zombie-ie-ie
[Em] What's in your head, [C] in your head
[G ] Zombie, zombie, [D] zombie-ie-ie, oh
```
<…>

