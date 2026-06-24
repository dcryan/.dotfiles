// usage.swift — cmux custom sidebar: a CLAUDE USAGE panel pinned above a clean
// workspace list. Usage rides hidden "sentinel" workspaces whose titles the
// cmux-usage-sentinels.sh poller keeps updated; this sidebar matches them by the
// "◈ " title prefix, renders them in the top panel, and hides them from the list.
//
// Palette: Ayu Mirage —  bg #1F2430 · fg #D9D7CE · dim #8A9199 · blue #73D0FF
//                        green #87D96C · orange #FFCC66 · selection #33415E
// No agent-state/bridge logic here — tmux-agentbar owns that. Rows show selection,
// unread, and repo (branch · dirty · PR) only.

// ── usage meters (hidden sentinels) ───────────────────────────────
// Match the poller's marker. The poller prefixes every meter title with "◈ " and
// real workspaces never start with it, so this is a collision-free anchor.
func isUsageMeter(_ w) -> Bool {
  return w.title.hasPrefix("◈ ")
}

// ── repo / git state ──────────────────────────────────────────────
func hasPR(_ w) -> Bool {
  return w.pr != nil && w.pr.label != nil && w.pr.label != ""
}
func hasBranch(_ w) -> Bool {
  return w.branch != nil && w.branch != ""
}
func hasRepoInfo(_ w) -> Bool {
  if hasPR(w) { return true }
  if hasBranch(w) { return true }
  if w.dirty == true { return true }
  return false
}
func repoText(_ w) -> String {
  if hasPR(w) {
    let stale = w.pr.stale == true ? " · stale" : ""
    return "\(w.pr.label)\(stale)"
  }
  if hasBranch(w) { return w.branch }
  return ""
}
func repoColor(_ w) -> String {
  if hasPR(w) && w.pr.status == "open" { return "#73D0FF" }
  return "#8A9199"
}

// needs-you = unread messages while you're away (native field, no bridge needed)
func needsYou(_ w) -> Bool {
  return w.unread > 0
}
func accentColor(_ w) -> String {
  if needsYou(w) { return "#FFCC66" }
  return "#73D0FF"
}
func accentOpacity(_ w) -> Double {
  if w.selected { return 1.0 }
  if needsYou(w) { return 0.9 }
  return 0.0
}
func rowFill(_ w) -> String {
  if w.selected { return "#33415E" }
  if needsYou(w) { return "#FFCC66" }
  return "#000000"
}
func rowFillOpacity(_ w) -> Double {
  if w.selected { return 0.85 }
  if needsYou(w) { return 0.08 }
  return 0.06
}

func row(_ w) -> some View {
  VStack(spacing: 0) {
    Button(action: { cmux("workspace.select", workspace_id: w.id) }) {
      HStack(alignment: .top, spacing: 10) {
        Capsule().frame(width: 3, height: 26)
          .foregroundColor(accentColor(w))
          .opacity(accentOpacity(w))
        VStack(alignment: .leading, spacing: 2) {
          HStack(alignment: .firstTextBaseline, spacing: 6) {
            // ⌘-number affordance. Custom sidebars can't detect the held Command key
            // (no modifier state) nor use .keyboardShortcut, so we show it always for
            // the first 9 workspaces. w.index+1 matches the real ⌘N selection shortcut.
            if w.index < 9 {
              Text("⌘\(w.index + 1)")
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(w.selected ? "#FFCC66" : "#5C6370")
            }
            Text(w.title)
              .font(.system(size: 14, design: .monospaced))
              .fontWeight(w.selected ? .bold : .medium)
              .foregroundColor(w.selected ? "#FFFFFF" : "#D9D7CE")
              .lineLimit(2).multilineTextAlignment(.leading)
          }
          if hasRepoInfo(w) {
            HStack(spacing: 4) {
              Image(systemName: "arrow.triangle.branch").font(.system(size: 9)).foregroundColor("#6E7787")
              Text(repoText(w))
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(repoColor(w))
                .lineLimit(1).truncationMode(.tail)
              if w.dirty == true {
                Text("*").font(.system(size: 12, design: .monospaced)).bold().foregroundColor("#FFCC66")
              }
            }
          }
        }
        Spacer()
        if w.unread > 0 {
          Text("\(w.unread)")
            .font(.system(size: 10, design: .monospaced)).bold()
            .foregroundColor("#1F2430").padding(4)
            .background { Circle().foregroundColor("#FFCC66") }
        }
        Button(action: { cmux("workspace.close", workspace_id: w.id) }) {
          Image(systemName: "xmark")
            .font(.system(size: 12)).foregroundColor("#6E7787")
            .frame(width: 22, height: 22)
        }
      }
      .padding(8)
      .background { RoundedRectangle(cornerRadius: 0).foregroundColor(rowFill(w)).opacity(rowFillOpacity(w)) }
    }
    .contextMenu {
      Button(action: { cmux("workspace.select", workspace_id: w.id) }) {
        Label("Open", systemImage: "arrow.right.circle")
      }
      if w.pinned {
        Button(action: { cmux("workspace.action", workspace_id: w.id, action: "unpin") }) {
          Label("Unpin", systemImage: "pin.slash")
        }
      } else {
        Button(action: { cmux("workspace.action", workspace_id: w.id, action: "pin") }) {
          Label("Pin", systemImage: "pin")
        }
      }
      Button(action: { cmux("workspace.action", workspace_id: w.id, action: "move-top") }) {
        Label("Move to top", systemImage: "arrow.up.to.line")
      }
      Divider()
      Button(action: { cmux("workspace.close", workspace_id: w.id) }) {
        Label("Close", systemImage: "xmark")
      }
    }
    Divider()
  }
}

// ── layout ────────────────────────────────────────────────────────
VStack(alignment: .leading, spacing: 0) {
  HStack(spacing: 10) {
    Text("Workspaces").font(.system(size: 14, design: .monospaced)).bold()
      .foregroundColor("#D9D7CE")
    Spacer()
    Text(clock.time).font(.system(size: 11, design: .monospaced)).foregroundColor("#707A8C")
  }
  .padding(9)
  Divider()

  // CLAUDE USAGE — the pinned panel. Titles are painted by cmux-usage-sentinels.sh as
  // "◈ <LABEL> · 5h <spark> <pct>% <reset>". Sorted so 5h sits above 7d per org.
  if workspaces.filter { isUsageMeter($0) }.count > 0 {
    VStack(alignment: .leading, spacing: 6) {
      Text("CLAUDE USAGE").font(.system(size: 10, design: .monospaced)).bold().foregroundColor("#8A9199")
      ForEach(workspaces.filter { isUsageMeter($0) }.sorted { $0.title < $1.title }) { w in
        Text(w.title)
          .font(.system(size: 12, design: .monospaced))
          .foregroundColor("#CCCAC2")
      }
    }
    .padding(9)
    Divider()
  }

  // WORKSPACES — header + count, then the draggable list (meters excluded).
  HStack(spacing: 8) {
    Text("WORKSPACES").font(.system(size: 10, design: .monospaced)).bold().foregroundColor("#8A9199")
    Spacer()
    Text("\(workspaces.filter { !isUsageMeter($0) }.count)")
      .font(.system(size: 10, design: .monospaced)).foregroundColor("#6E7787")
  }
  .padding(9)
  Divider()

  Reorderable(workspaces.filter { !isUsageMeter($0) }.sorted { $0.index < $1.index }, move: "workspace.reorder") { w in
    row(w)
  }
  Spacer()
}
