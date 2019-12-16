# File to be dot sourced by main scripts
# Generate a password similar to one generated by Office 365

function newPassword() {

    $cu = "BCDFGHJKLMNPQRSTVWXYZ"
    $cl = "bcdfghjklmnpqrstyvwxyz"
    $vl = "aeiou"
    
    $banned = @(`
        "fuc", "fuk", "fuq", "fux", "coc", "cok", "coq", "kox", "koc", "kok", "koq", `
        "cac", "cak", "caq", "kac", "kak", "kaq", "dic", "dik", "diq", "dix", "fag", `
        "nig", "cum", "kum", "suc", "suk", "suq", "lic", "lik", "liq", "jiz", "gay", `
        "gey", "vag", "fap", "lol", "jew", "joo", "pus", "pis", "tit", "hor", "jap", `
        "wop", "kik", "mic", "mik", "miq", "guc", "guk", "guq", "giz", "sex", "wac", `
        "wak", "waq", "pot", "vaj", "nut", "poo", "muf", "tok", "toc", "toq", "rac", `
        "rak", "raq", "sac", "sak", "saq", "nad", "sol", "sob", "fob", "bum", "lab", `
        "con", "lib" `
    )

    do {
        $pwd = $cu[$(Get-Random -Maximum $cu.Length)]
        $pwd += $vl[$(Get-Random -Maximum $vl.Length)]
        $pwd += $cl[$(Get-Random -Maximum $cl.Length)]
    } until ($banned -notcontains $pwd)

    $pwd += Get-Random -Minimum 10000 -Maximum 99999
    
    $pwd
}