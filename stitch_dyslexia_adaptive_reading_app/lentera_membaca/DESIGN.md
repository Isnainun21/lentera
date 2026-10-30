---
name: Lentera Membaca
colors:
  surface: '#f9f9fd'
  surface-dim: '#d9dade'
  surface-bright: '#f9f9fd'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f7'
  surface-container: '#ededf1'
  surface-container-high: '#e8e8ec'
  surface-container-highest: '#e2e2e6'
  on-surface: '#1a1c1f'
  on-surface-variant: '#3c4947'
  inverse-surface: '#2f3034'
  inverse-on-surface: '#f0f0f4'
  outline: '#6c7a77'
  outline-variant: '#bbcac6'
  surface-tint: '#006a61'
  primary: '#006a61'
  on-primary: '#ffffff'
  primary-container: '#38c6b6'
  on-primary-container: '#004e46'
  inverse-primary: '#53dbca'
  secondary: '#ae2f34'
  on-secondary: '#ffffff'
  secondary-container: '#ff6b6b'
  on-secondary-container: '#6d0010'
  tertiary: '#745b00'
  on-tertiary: '#ffffff'
  tertiary-container: '#d8ad0d'
  on-tertiary-container: '#554200'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#74f8e6'
  primary-fixed-dim: '#53dbca'
  on-primary-fixed: '#00201c'
  on-primary-fixed-variant: '#005049'
  secondary-fixed: '#ffdad8'
  secondary-fixed-dim: '#ffb3b0'
  on-secondary-fixed: '#410006'
  on-secondary-fixed-variant: '#8c1520'
  tertiary-fixed: '#ffe08a'
  tertiary-fixed-dim: '#eec12a'
  on-tertiary-fixed: '#241a00'
  on-tertiary-fixed-variant: '#574400'
  background: '#f9f9fd'
  on-background: '#1a1c1f'
  surface-variant: '#e2e2e6'
typography:
  headline-xl:
    fontFamily: Lexend
    fontSize: 40px
    fontWeight: '800'
    lineHeight: 52px
    letterSpacing: 0.02em
  headline-xl-mobile:
    fontFamily: Lexend
    fontSize: 30px
    fontWeight: '800'
    lineHeight: 40px
    letterSpacing: 0.02em
  headline-lg:
    fontFamily: Lexend
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: 0.02em
  headline-lg-mobile:
    fontFamily: Lexend
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: 0.02em
  headline-md:
    fontFamily: Lexend
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: 0.015em
  headline-sm:
    fontFamily: Lexend
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: 0.015em
  body-reading-lg:
    fontFamily: Lexend
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 38px
    letterSpacing: 0.04em
  body-reading-md:
    fontFamily: Lexend
    fontSize: 18px
    fontWeight: '500'
    lineHeight: 32px
    letterSpacing: 0.035em
  body-lg:
    fontFamily: Lexend
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 26px
    letterSpacing: 0.01em
  body-md:
    fontFamily: Lexend
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 22px
    letterSpacing: 0.01em
  label-lg:
    fontFamily: Lexend
    fontSize: 15px
    fontWeight: '700'
    lineHeight: 20px
    letterSpacing: 0.03em
  label-md:
    fontFamily: Lexend
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.025em
  syllable-display:
    fontFamily: Lexend
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: 0.08em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-tablet: 1.5rem
  margin: 1.25rem
  margin-tablet: 2rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
  space-2xl: 3rem
---

## Brand & Style

This design system is crafted specifically for an adaptive literacy platform supporting children with dyslexia and diverse reading capabilities. The brand spirit embodies warmth, unhurried encouragement, clarity, and joyful play. The design eliminates sensory overwhelm, cognitive friction, and visual distortion, replacing academic anxiety with tangible, celebratory progression.

The visual style merges **Warm Tactile Minimalism** with **Playful Soft Geometry**:
- **Glare-Free Low-Strain Surfaces:** Harsh bright whites and pitch blacks cause high-contrast visual stress and typographic distortion for dyslexic readers. The foundation rests on velvety warm cream substrates layered with pillowy cards.
- **Physical, Squishy Tactility:** Buttons, tiles, and tokens mimic physical wooden or soft-rubber play learning blocks with deep rounded profiles and subtle bottom-weight offset shadows that invite interaction.
- **Supportive Neurodiversity Focus:** Every interface state—from letterforms to rewards—prioritizes letter disambiguation, spatial predictability, multisensory reassurance (audio-haptic visual synchrony), and micro-celebrations.

## Colors

Color is treated both as an emotional stabilizer and a structural guide for attention. High-frequency sensory saturation is avoided in favor of warm, saturated accents on balanced tinted grounds.

### Palette Architecture
- **Primary (Mint Teal - `#38C6B6`):** The primary brand anchor denoting safety, action, forward progress, and completed milestones. Highly visible and calming.
- **Secondary (Warm Coral Red - `#FF6B6B`):** Energetic, affectionate accent for attention, phoneme emphasis, live feedback, and emotional celebration. Never used harshly for failure or punishment states.
- **Tertiary (Sunny Butter Yellow - `#FFD13B`):** Used for tactile reward indicators, stars, streak counts, audio active states, and phoneme highlighting cues.
- **Soft Lavender (`#E6E0F8`):** Gentle contextual background for secondary interactive controls, phonics grouping containers, and calm reading zones.
- **Soft Peach / Surface Tint (`#FFF3EB`):** Secondary container surface and warm highlight tone that harmonizes with playful accents.
- **Canvas Neutral (`#F8F5F0`):** Off-white ivory canvas that cuts down luminance glare and visual vibration for dyslexic readers.
- **Elevated Neutral Surface (`#FFFFFF`):** High-clarity foreground cards.
- **Text Primary (`#1F2124`):** Deep charcoal slate. Pure black (`#000000`) is explicitly prohibited to prevent high-contrast typographic vibration.
- **Text Secondary (`#525866`):** Balanced mid-charcoal providing AA/AAA compliant contrast for helper cues, meta badges, and subtitles.

## Typography

Lexend was chosen for its research-backed design intended to reduce visual crowding and enhance reading fluency for dyslexic readers.

### Typographic Rules
- **Line Height & Spacing Ratios:** All reading passages mandate a relaxed 1.7x to 1.9x line height to prevent line jumping (crowding).
- **Expanded Letter-Spacing:** Character-tracking is intentionally boosted (`+0.015em` to `+0.08em` across styles) to maintain explicit boundary differentiation between mirroring letters (`b`, `d`, `p`, `q`).
- **Word & Syllable Spacing:** Syllables and instructional reading chunks utilize `syllable-display` with distinct letter tracking (`0.08em`) to enable immediate phonetic decoding.
- **No Justified Text:** Reading passages must always be left-aligned with ragged right margins to maintain steady spatial references and eliminate uneven "rivers" of white space.

## Layout & Spacing

The layout is built around mobile-first touch ergonomics designed for small hands and variable motor coordination. Touch targets exceed standard guidelines, prioritizing comfortable spatial padding around each interactive target.

### Layout Principles
- **Grid Structure:** A fluid 4-column layout on mobile devices (`360px` - `599px`) expanding to an 8-column layout on tablets (`600px` - `1024px`).
- **Breathing Margin:** Screen edges enforce a safe boundary (`margin`: `1.25rem` mobile, `2rem` tablet) to protect content from incidental touches and thumb wrapping.
- **Rhythmic Stacking:** Spacing between task modules uses `space-lg` (`1.5rem`) to cleanly segment learning activities. Groupings within cards leverage `space-sm` (`0.5rem`) and `space-md` (`1rem`) to keep cognitive relationships unmistakable.
- **One Focus Rule:** Activity screens present a single primary cognitive challenge per viewport, tucking administrative meta controls into an accessible persistent header.

## Elevation & Depth

Visual hierarchy uses physical, approachable tactile depth rather than stark geometric borders or harsh drops.

### Elevation Levels
- **Canvas Base (Level 0):** The soothing warm ivory canvas (`#F8F5F0`). Flat, non-interactive.
- **Soft Floating Surface (Level 1):** Main card wrappers and content sections (`#FFFFFF`). Utilizes an ambient, extra-diffused warm drop shadow: `0px 8px 24px -4px rgba(31, 33, 36, 0.05), 0px 2px 6px -1px rgba(31, 33, 36, 0.03)`.
- **Interactive Chunky Element (Level 2):** Pushable buttons, phoneme cards, and syllable chips. Uses a subtle physical bottom bevel: a solid colored offset shadow (`box-shadow: 0px 4px 0px 0px rgba(0, 0, 0, 0.12)` or darker shade of the element's primary color) plus a soft diffused halo `0px 8px 16px rgba(56, 198, 182, 0.18)`.
- **Active / Pressed State (Level 0 - Inset Tactile):** When tapped, interactive elements translate down 3px (`transform: translateY(3px)`), flattening their bottom shadow to simulate a reassuring mechanical click.
- **Reading Ruler Overlay (Level 3):** Translucent focusing guide hovering above reading text with subtle edge blur and a focused amber/mint highlight halo.

## Shapes

The design system embraces an ultra-friendly, non-threatening geometry. Harsh right angles and razor corners are removed entirely to avoid tension and accidental optical traps.

### Curvature Specifications
- **Cards & Primary Modules:** Enforce a signature `24px` (`rounded-2xl`) corner radius.
- **Interactive Buttons & Badges:** Utilize full pill geometry (`border-radius: 9999px`) to invite fingertips.
- **Action Icons & Progress Pods:** Nestled inside pure geometric circles (`aspect-ratio: 1/1; border-radius: 50%`).
- **Phoneme & Word Tiles:** Feature squircle curvature (`16px` to `20px` radius) providing a tactile hand-held block feel.

## Components

### Buttons
- **Primary Action (Mint Bounce):** Mint Teal (`#38C6B6`) background with pure white text (`headline-sm`), min-height of `56px`, full pill radius (`9999px`). Features a deep bottom offset `box-shadow: 0 4px 0 #289F92`. In active state, compresses down `transform: translateY(3px)` with `0 1px 0 #289F92`.
- **Secondary Action (Warm Support):** Soft Lavender (`#E6E0F8`) surface with Deep Charcoal (`#1F2124`) text, paired with `box-shadow: 0 4px 0 #D0C6EF`.
- **Celebration / Audio Button:** Sunny Butter Yellow (`#FFD13B`) circular button with tactile depth, housing playful high-contrast iconography.

### Chips & Status Tags
- **Level & Metric Badges:** Pill-shaped capsules with generous vertical padding (`6px 14px`). For example:
  - *Accuracy Tag:* Warm Mint tint background (`#E6F9F7`) with `#289F92` bold label text (`label-md`).
  - *Level Tag:* Soft Peach background (`#FFF3EB`) with Warm Coral Red (`#E04F4F`) label text.
- Badges carry no hard borders; differentiation occurs via light tonal fills and clear typographic weight.

### Reading Ruler & Focus Guide
- An assistive component that dims background text to 40% opacity while keeping the currently targeted 1–2 lines fully illuminated over a tinted butter-yellow or soft-mint horizontal track (`#FFD13B` at 12% opacity with rounded edges).
- Includes an adjustable drag handle and an integrated audio trigger button anchored on the trailing edge.

### Syllable Breakdown Tiles (Gamified Phonics)
- Chunky, individual block cards containing distinct syllables (e.g., [LEM] [BA] [R]).
- Rendered on pure white surfaces with a 16px corner radius and a 2px outline in Soft Lavender (`#E6E0F8`).
- Active or tapped syllables pulse into Mint Teal (`#38C6B6`) with elevated bounce and play an instant clear audio pronunciation cue.
- Confusing letter pairs (e.g., `b` vs `d`) feature a subtle directional anchor dot beneath the ascender to reinforce spatial orientation.

### Audio Pronunciation Cues
- Persistent circular floating or inline speaker triggers (`44x44px` minimum touch target).
- Features radiating ripple animation when voice synthesis or phoneme playback is engaged, synchronizing visual rhythm with acoustic feedback.

### Form Inputs & Character Selectors
- Background: `#FFFFFF` with a soft 2px neutral border (`#E5DFD7`).
- Active/Focused state: transitions to a 2.5px Mint Teal (`#38C6B6`) outline accompanied by a gentle ambient glow.
- Placeholder text: Deep Secondary Charcoal (`#525866` at 70% opacity) set at `body-reading-md` to maintain legibility.

### Cards & Container Modules
- Elevated soft white containers (`#FFFFFF`) with 24px corner radius, internal padding of `20px` to `24px`, and subtle diffused ambient shadow. Grouped elements within a card maintain consistent `12px` to `16px` vertical gaps to prevent visual crowding.