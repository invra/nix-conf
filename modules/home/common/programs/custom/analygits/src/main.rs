use {
    colored::Colorize, file_type::FileType, git2::Repository, ignore::WalkBuilder, regex::Regex,
    std::collections::HashMap, std::fs,
};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let repo = Repository::discover(".")?;
    let repo_path = repo.path().parent().unwrap();

    let head = repo.head().ok();
    let branch = head
        .and_then(|h| h.shorthand().map(|s| s.to_string()))
        .unwrap_or("unknown".to_string());

    let remote_url = repo
        .find_remote("origin")
        .and_then(|r| {
            r.url()
                .map(|s| s.to_string())
                .ok_or(git2::Error::from_str("No URL"))
        })
        .unwrap_or_else(|_| repo_path.to_string_lossy().into_owned());

    println!("Repository: {remote_url} (branch {branch})\n");

    let mut revwalk = repo.revwalk()?;
    revwalk.push_head()?;

    let mut author_counts: HashMap<String, usize> = HashMap::new();
    let mut commits: Vec<git2::Oid> = Vec::new();

    for oid_result in revwalk {
        let oid = oid_result?;
        if let Ok(commit) = repo.find_commit(oid) {
            let author_sig = commit.author();
            let name = author_sig.name().unwrap_or("Unknown");
            let email = author_sig.email().unwrap_or("unknown@example.com");

            let author_key = format!("{} <{}>", name, email);
            *author_counts.entry(author_key).or_insert(0) += 1;

            commits.push(oid);
        }
    }

    let mut authors: Vec<_> = author_counts.into_iter().collect();
    authors.sort_by(|a, b| b.1.cmp(&a.1));
    println!("Top Authors:");
    for (author, count) in authors.iter().take(3) {
        println!("  {} ({} commits)", author, count);
    }

    let milestones = [100, 250, 500, 750, 1000, 5000, 10000, 100000, 1000000];
    let total_commits = commits.len();
    println!("\nCommit Milestones:");
    for &m in &milestones {
        if m <= total_commits {
            let commit = repo.find_commit(commits[total_commits - m])?;
            let msg = commit.summary().unwrap_or("<no message>");
            println!(
                "  {}th commit: {} by {} <{}>",
                m,
                msg,
                commit.author().name().unwrap_or(""),
                commit.author().email().unwrap_or("")
            );
        }
    }

    let mut lang_map: HashMap<&str, &str> = HashMap::new();
    lang_map.insert("rs", "Rust");
    lang_map.insert("c", "C");
    lang_map.insert("h", "C Header");
    lang_map.insert("lua", "Lua");
    lang_map.insert("cc", "C++");
    lang_map.insert("cpp", "C++");
    lang_map.insert("hpp", "C++ Header");
    lang_map.insert("py", "Python");
    lang_map.insert("js", "JavaScript");
    lang_map.insert("ts", "TypeScript");
    lang_map.insert("tsx", "React TSX");
    lang_map.insert("jsx", "React JSX");
    lang_map.insert("java", "Java");
    lang_map.insert("go", "Go");
    lang_map.insert("rb", "Ruby");
    lang_map.insert("php", "PHP");
    lang_map.insert("swift", "Swift");
    lang_map.insert("nix", "Nix");
    lang_map.insert("toml", "TOML");
    lang_map.insert("yaml", "YAML");
    lang_map.insert("yml", "YAML");
    lang_map.insert("json", "JSON");
    lang_map.insert("md", "Markdown");
    lang_map.insert("adoc", "ASCIIDoc");
    lang_map.insert("org", "Org-mode");
    lang_map.insert("html", "HTML");
    lang_map.insert("css", "CSS");
    lang_map.insert("scss", "SCSS");

    let blacklist = Regex::new(r"(?i)^(README|TODO|CONTRIBUTING)\.").unwrap();

    let mut lang_counts: HashMap<&str, usize> = HashMap::new();
    let mut file_lines: HashMap<String, usize> = HashMap::new();

    for entry in WalkBuilder::new(repo_path).hidden(false).build() {
        if let Ok(entry) = entry {
            if entry.file_type().map(|t| t.is_file()).unwrap_or(false) {
                let file_name = entry
                    .path()
                    .file_name()
                    .and_then(|n| n.to_str())
                    .unwrap_or("");
                if blacklist.is_match(file_name) {
                    continue;
                }

                if let Some(ext) = entry.path().extension().and_then(|e| e.to_str()) {
                    let file_type = FileType::from_bytes(b"\xCA\xFE\xBA\xBE");
                    if let Some(lang) = FileType::from_extension(ext) {
                        if let Ok(content) = fs::read_to_string(entry.path()) {
                            let line_count = content.lines().count();
                            *lang_counts.entry(lang).or_insert(0) += line_count;
                            file_lines.insert(entry.path().display().to_string(), line_count);
                        }
                    }
                }
            }
        }
    }

    let mut top_files: Vec<_> = file_lines.into_iter().collect();
    top_files.sort_by(|a, b| b.1.cmp(&a.1));
    println!("\nTop 5 Files (by LOC):");
    for (file, count) in top_files.into_iter().take(5) {
        println!("  {}: {} lines", file, count);
    }

    let mut langs: Vec<_> = lang_counts.into_iter().collect();
    langs.sort_by(|a, b| b.1.cmp(&a.1));
    let total_lines: usize = langs.iter().map(|(_, c)| c).sum();

    println!("\nDetected Languages (sorted by LOC):");
    for (lang, count) in langs {
        let percent = (count as f64 / total_lines as f64) * 100.0;
        let bar_len = (percent / 2.0) as usize;
        println!("  {:<15} {:>6} lines |{}", lang, count, "█".repeat(bar_len));
    }

    println!("\x1b[38;2;25;25;235mhello\x1b[0m");

    Ok(())
}
