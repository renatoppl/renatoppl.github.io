#!/bin/bash

# 1. Create directory structure
echo "Creating 'lib' directory..."
mkdir -p lib/fonts

# 2. Download Marked.js
echo "Downloading Marked.js..."
curl -L https://cdn.jsdelivr.net/npm/marked/marked.min.js -o lib/marked.js

# 3. Download KaTeX (Release Tarball)
# Downloading the official release ensures we get the CSS and correct font files structure automatically.
echo "Downloading and extracting KaTeX..."
curl -L https://github.com/KaTeX/KaTeX/releases/download/v0.16.9/katex.tar.gz -o katex.tar.gz
tar -xzf katex.tar.gz
# Move contents: katex/dist/* -> lib/
# We only need the contents of the 'dist' folder from the archive
cp -r katex/dist/* lib/
# Cleanup
rm -rf katex katex.tar.gz

# 4. Download CMU Sans Serif Fonts (The LaTeX Font)
# We download only the Sans Serif variations (Normal, Bold, Oblique, Bold-Oblique)
echo "Downloading CMU Sans Serif fonts..."
cmu_base="https://cdn.jsdelivr.net/npm/fonts-cmu@1.0.0/fonts"
fonts=("cmunss.woff2" "cmunss-bold.woff2" "cmunss-oblique.woff2" "cmunss-bold-oblique.woff2")

for font in "${fonts[@]}"; do
    echo "Fetching $font..."
    curl -L "$cmu_base/$font" -o "lib/fonts/$font"
done

# 5. Generate local CSS for the Fonts
# This creates a CSS file that points to the fonts we just downloaded.
echo "Generating lib/cmu-sans.css..."
cat > lib/cmu-sans.css <<EOF
@font-face {
  font-family: 'Computer Modern Sans';
  src: url('fonts/cmunss.woff2') format('woff2');
  font-weight: normal;
  font-style: normal;
}
@font-face {
  font-family: 'Computer Modern Sans';
  src: url('fonts/cmunss-bold.woff2') format('woff2');
  font-weight: bold;
  font-style: normal;
}
@font-face {
  font-family: 'Computer Modern Sans';
  src: url('fonts/cmunss-oblique.woff2') format('woff2');
  font-weight: normal;
  font-style: italic;
}
@font-face {
  font-family: 'Computer Modern Sans';
  src: url('fonts/cmunss-bold-oblique.woff2') format('woff2');
  font-weight: bold;
  font-style: italic;
}
EOF

echo "Done! Assets are in the 'lib' folder."
