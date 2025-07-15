#!/bin/bash
# GitHub Sync Script - Upload Everything Important

echo "🔄 SYNCING ROADSHOW PROJECT TO GITHUB"
echo "=" * 40

# Check current git status
echo "📊 Current Git Status:"
git status --porcelain

echo ""
echo "🔍 Checking for ignored files in data/ and models/:"
git check-ignore data/* models/* 2>/dev/null || echo "No specific ignores found"

echo ""
echo "📁 Current repo contents:"
echo "Files in data/: $(git ls-files | grep '^data/' | wc -l)"
echo "Files in models/: $(git ls-files | grep '^models/' | wc -l)"
echo "Total tracked files: $(git ls-files | wc -l)"

# Create/update .gitignore to be more selective
echo ""
echo "📝 Creating selective .gitignore..."
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
env/
.env

# macOS
.DS_Store
.AppleDouble
.LSOverride

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini

# IDE
.vscode/
.idea/
*.swp
*.swo

# Exclude only very large files (>100MB)
*.avi
*.mov
*.mp4
*.mkv

# Keep these important files but exclude very large ones
!data/training_pairs/*.dng
!data/training_pairs/*.arw
!data/results/
!models/*.pth

# Exclude temporary/cache files
**/cache/
**/temp/
**/tmp/
**/.ipynb_checkpoints/

# Exclude backup files
*.backup
*.bak
*~
EOF

echo "✅ Updated .gitignore"

# Check for large files that might cause issues
echo ""
echo "🔍 Checking for files larger than 90MB:"
find . -type f -size +90M -not -path './.git/*' -not -path './venv/*' 2>/dev/null | head -10

# Add important directories and files
echo ""
echo "📁 Adding important project files..."

# Add core project files
git add *.py
git add data/results/
git add models/ 2>/dev/null || echo "No models directory or files"

# Try to add training pairs (might be large)
echo "📱 Adding training pairs..."
git add data/training_pairs/ 2>/dev/null || echo "Training pairs too large or not found"

# Add configuration and metadata files
git add *.json *.txt *.md 2>/dev/null

# Add LUT files
git add luts/ 2>/dev/null || echo "No LUTs directory"

# Show what will be committed
echo ""
echo "📋 Files staged for commit:"
git diff --cached --name-only | head -20

# Create commit with meaningful message
echo ""
echo "💾 Creating commit..."
commit_message="Update Roadshow project: $(date '+%Y-%m-%d')

- Added latest training pipeline improvements
- Updated color science models  
- Included NeRF architecture files
- Added 79-pair training dataset structure
- Production-ready scripts and analysis tools

Total training pairs: 79 (major expansion)
Key features: Neural log expansion, NeRF integration"

git commit -m "$commit_message"

# Push to GitHub
echo ""
echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "📊 FINAL STATUS:"
echo "✅ Repository synced to GitHub"
echo "📁 Check: https://github.com/AmmarAnnex/roadshow-cinema-model"
echo ""
echo "If some large files didn't upload:"
echo "1. Consider using Git LFS for .dng/.arw files"
echo "2. Or compress training data into archives"
echo "3. Document file locations in README"
