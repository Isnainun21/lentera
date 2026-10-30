---
name: Clarity & Calm
colors:
  surface: '#f8f9fb'
  surface-dim: '#d9dadc'
  surface-bright: '#f8f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f6'
  surface-container: '#edeef0'
  surface-container-high: '#e7e8ea'
  surface-container-highest: '#e1e2e4'
  on-surface: '#191c1e'
  on-surface-variant: '#45474a'
  inverse-surface: '#2e3132'
  inverse-on-surface: '#f0f1f3'
  outline: '#76777b'
  outline-variant: '#c6c6ca'
  surface-tint: '#5d5e62'
  primary: '#030406'
  on-primary: '#ffffff'
  primary-container: '#1c1e21'
  on-primary-container: '#848689'
  inverse-primary: '#c6c6ca'
  secondary: '#585f6c'
  on-secondary: '#ffffff'
  secondary-container: '#dce2f3'
  on-secondary-container: '#5e6572'
  tertiary: '#060402'
  on-tertiary: '#ffffff'
  tertiary-container: '#221d18'
  on-tertiary-container: '#8d847d'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2e2e6'
  primary-fixed-dim: '#c6c6ca'
  on-primary-fixed: '#1a1c1f'
  on-primary-fixed-variant: '#45474a'
  secondary-fixed: '#dce2f3'
  secondary-fixed-dim: '#c0c7d6'
  on-secondary-fixed: '#151c27'
  on-secondary-fixed-variant: '#404754'
  tertiary-fixed: '#ebe1d8'
  tertiary-fixed-dim: '#cfc5bd'
  on-tertiary-fixed: '#201b16'
  on-tertiary-fixed-variant: '#4c4640'
  background: '#f8f9fb'
  on-background: '#191c1e'
  surface-variant: '#e1e2e4'
typography:
  headline-xl:
    fontFamily: Lexend
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: 0.02em
  headline-xl-mobile:
    fontFamily: Lexend
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: 0.02em
  headline-lg:
    fontFamily: Lexend
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 46px
    letterSpacing: 0.025em
  headline-lg-mobile:
    fontFamily: Lexend
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: 0.02em
  headline-md:
    fontFamily: Lexend
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: 0.03em
  body-xl:
    fontFamily: Lexend
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 38px
    letterSpacing: 0.04em
  body-lg:
    fontFamily: Lexend
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 32px
    letterSpacing: 0.035em
  body-md:
    fontFamily: Lexend
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 28px
    letterSpacing: 0.03em
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0.02em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.025em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.04em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1.5rem
  gutter-mobile: 1rem
  margin: 2.5rem
  margin-mobile: 1.25rem
  space-xs: 0.5rem
  space-sm: 0.75rem
  space-md: 1.25rem
  space-lg: 2rem
  space-xl: 3rem
---

## Brand & Style

This design system is engineered for neurodiverse young learners—specifically children with dyslexia—focusing on adaptive early reading and linguistic confidence. It pairs the structural discipline of modern high-contrast minimalism with the warm, reassuring tactility of extra-rounded cards and floating elements. 

The aesthetic eliminates sensory overwhelm. Rather than relying on loud, distracting multi-color gamification palettes that cause visual crowding and cognitive fatigue, the experience relies on a disciplined monochrome foundation: an ultra-soft glare-reducing cool gray canvas, floating crisp white tactile surfaces, deep charcoal interactive anchors, and deliberate spatial rhythm. The emotional response is calm focus, cognitive ease, safety, and empowering clarity.

## Colors

The palette is strictly calibrated to prevent visual stress, scotopic sensitivity, and optical vibration:

- **Canvas Background (`#F4F5F7`):** An ultra-soft, low-luminance cool gray base. It completely avoids pure white glare across large viewports, directly addressing reading fatigue for dyslexic children.
- **Surface & Cards (`#FFFFFF`):** Pure white reserved exclusively for actionable modules, reading lesson cards, and interactive content containers. This clear delta against the canvas provides natural, distinct boundaries without aggressive borders.
- **Primary Accent (`#1C1E21`):** Deep charcoal black. Used for maximum typographic contrast, active interactive states, primary action buttons, focused pill toggles, and floating dock navigation elements. It avoids harsh `#000000` pitch black to maintain softness on letterforms while keeping WCAG AAA legibility.
- **Secondary Neutral (`#6B7280`):** Cool slate gray for secondary metadata, phoneme guidance instructions, and resting icon states.
- **Borders & Dividers (`#E5E7EB`):** A soft, featherweight neutral line used sparingly to reinforce card silhouettes when placed over variable imagery or subtle backgrounds.

## Typography

Typography is the core therapeutic element of this design system. We utilize **Lexend** for all primary learning content, reading passages, phonics tasks, and structural headings. Lexend is purposefully engineered to improve reading fluency and decrease character collisions by expanding inner letter loops and widening glyph proportions.

- **Tracking & Kerning:** Letter spacing is explicitly loosened (`0.02em` to `0.04em`) across all roles to prevent letter crowding, swapping, and mirror-flipping (`b` vs `d`, `p` vs `q`).
- **Line Heights:** Line heights are significantly relaxed (1.6x to 1.8x character size) to guide the child's scanning eye smoothly across lines without accidental line jumping.
- **Support Font:** **Plus Jakarta Sans** is leveraged exclusively for UI labels, badges, tactile controls, and status pills, maintaining clear structural contrast between the child's reading text and device interface labels.

## Layout & Spacing

The layout philosophy centers on spatial breathing room and cognitive isolation. Clustered data is strictly avoided; individual concepts and reading steps are awarded generous physical boundaries.

- **Grid Architecture:** 
  - **Desktop / Tablet (Landscape):** An 8-column layout capped at a maximum width of `1120px` to maintain comfortable eye-scanning spans. Gutters are locked at `1.5rem` (`24px`).
  - **Mobile / Tablet (Portrait):** A single-column or 2-column stacked fluid layout with `1rem` (`16px`) gutters and `1.25rem` (`20px`) outer safety margins.
- **Rhythm & Touch Targets:** All interactive reading cards, phoneme tiles, and buttons adhere to a minimum hit-box size of `56px` to accommodate developing motor skills and reduce tap anxiety. Vertical spacing between distinct lesson segments prioritizes `space-xl` (`48px`) to enforce progressive disclosure.

## Elevation & Depth

Visual hierarchy is communicated through floating physical planes rather than rigid, clinical lines. The elevation system separates content into distinct spatial tiers:

1. **Base Tier (Canvas):** The flat `#F4F5F7` backdrop provides a low-strain ambient foundation.
2. **Surface Tier (Lesson & Content Cards):** Crisp `#FFFFFF` containers elevated via ultra-diffused, ambient drop shadows:
   - `box-shadow: 0 10px 30px -8px rgba(28, 30, 33, 0.05), 0 4px 12px -4px rgba(28, 30, 33, 0.03);`
   - Border: `1px solid rgba(229, 231, 235, 0.7)` for clean edge definition against the soft base.
3. **Floating Interaction Tier (Floating Docks & Critical Modals):** Deep charcoal structures `#1C1E21` floating over content with a high-elevation shadow:
   - `box-shadow: 0 20px 40px -10px rgba(28, 30, 33, 0.22);`
4. **Glassmorphism Overlays:** Semi-translucent dark surfaces (`rgba(28, 30, 33, 0.88)` with `backdrop-filter: blur(16px)`) used for the persistent bottom navigation dock, secondary controls, and speech-feedback indicators.

## Shapes

The design system employs an exaggerated, welcoming pill-and-capsule geometry (`roundedness: 3`):

- **Cards & Reading Surfaces:** Radiuses range from `28px` to `32px` (`rounded-xl`), removing harsh corners to foster an approachable, non-threatening learning environment.
- **Buttons, Badges & Chips:** Completely pill-shaped (`border-radius: 9999px`) to invite natural fingertip interaction.
- **Phoneme & Letter Tiles:** Square-proportioned modules soften their corners at a steady `20px` radius, giving each sound block the feel of a smooth wooden or plastic physical toy.

## Components

### 1. Primary Action Buttons (Dark Glass & Charcoal)
- **Geometry:** Pill-shaped (`border-radius: 9999px`), minimum height `56px`, horizontal padding `32px`.
- **States:** Solid `#1C1E21` background, white label typography (`Plus Jakarta Sans`, 16px, weight 600). 
- **Hover/Active:** Subtle scaling down (`transform: scale(0.98)`), shadow intensity deepens. Secondary dark variant uses dark glass: `rgba(28, 30, 33, 0.82)` with `backdrop-filter: blur(12px)`.

### 2. Reading Content Cards
- **Geometry:** `28px` to `32px` border-radius, pure `#FFFFFF` background, subtle boundary border `1px solid #E5E7EB`.
- **Padding:** Generous internal padding (`32px` desktop, `24px` mobile).
- **Behavior:** Houses rich visual illustrations, audio trigger buttons, and high-legibility syllable breakdowns with distinct phoneme highlights.

### 3. Floating Pill Dock (Navigation)
- **Geometry:** Floating anchored dock positioned `24px` above the bottom screen margin. Pill radius (`9999px`), background `rgba(28, 30, 33, 0.92)` with `backdrop-filter: blur(20px)`.
- **Items:** Pure white high-contrast icons for active routes, muted slate (`#9CA3AF`) for inactive destinations. Active selection is indicated by an inset soft pill badge (`rgba(255, 255, 255, 0.14)`).

### 4. Interactive Syllable & Phoneme Chips
- **Geometry:** Pill capsules (`9999px`), height `44px`, padding `6px 20px`.
- **Resting:** `#FFFFFF` fill with `1.5px solid #E5E7EB`, text `#1C1E21`.
- **Active / Read State:** `#1C1E21` fill, text `#FFFFFF`, elevation shadow.

### 5. Checkboxes & Radio Selection Tiles
- **Philosophy:** Standard microscopic checkboxes are eliminated in favor of full tactile selection cards.
- **Card Selection:** Entire card acts as the toggle. Unselected cards maintain a `#FFFFFF` fill and `#E5E7EB` outline. Selected cards transition to an active `#1C1E21` stroke (2.5px width) and an inner solid dark check badge.

### 6. Audio-Assistive Text Inputs
- **Geometry:** Minimum `56px` height, `20px` corner radius, `#FFFFFF` fill, `#E5E7EB` border.
- **Focus:** Sharp `#1C1E21` border with a soft `4px` outer ring (`rgba(28, 30, 33, 0.08)`).
- **Features:** Integrated persistent microphone speech-to-text icon pill on the trailing edge for verbal dyslexic input.