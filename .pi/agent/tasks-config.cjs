module.exports = {
  collapseCompleted: true,
  sortOrder: (a, b) => {
    const rank = { in_progress: 0, pending: 1, completed: 2 };
    return rank[a.status] - rank[b.status] || Number(a.id) - Number(b.id);
  },
};
