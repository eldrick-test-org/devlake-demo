-- ============================================================================
-- DORA Metrics Dashboard Seed Data
-- Target: devlake-demo-mysql-1 (port 3307)
-- Run: docker exec -i devlake-demo-mysql-1 mysql -umerico -pmerico lake < scripts/seed_dora.sql
-- ============================================================================

-- =============================================================================
-- Step 1: Create a project for DORA metrics
-- =============================================================================
INSERT INTO projects (name, description, created_at, updated_at)
VALUES ('dora-demo-project', 'Demo project for DORA metrics', NOW(), NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- =============================================================================
-- Step 2: Create repos table entry (needed for proper linkage)
-- =============================================================================
INSERT IGNORE INTO repos (id, name, url, created_date, updated_date)
VALUES 
  ('github:GithubRepo:1:dora-demo-001', 'dora-demo-repo', 'https://github.com/demo/dora-demo', NOW(), NOW());

-- =============================================================================
-- Step 3: Clear old DORA seed data
-- =============================================================================
DELETE FROM project_mapping WHERE project_name = 'dora-demo-project';
DELETE FROM cicd_deployment_commits WHERE id LIKE 'dora-%';
DELETE FROM pull_requests WHERE id LIKE 'dora-pr-%';
DELETE FROM project_pr_metrics WHERE id LIKE 'dora-pr-%';
DELETE FROM incidents WHERE id LIKE 'dora-incident-%';

-- =============================================================================
-- Step 4: Create Deployment Data (13 weeks)
-- Increasing deployment frequency over time
-- =============================================================================

-- Week 1 (Nov 4, 2025) - 1 deploy
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, cicd_scope_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES ('dora-deploy-w01-1', 'dora-deploy-w01-1', 'github:GithubRepo:1:dora-demo-001', 'sha0101', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-11-06 10:00:00', '2025-11-06 09:30:00');

-- Week 2 (Nov 11, 2025) - 1 deploy
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, cicd_scope_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES ('dora-deploy-w02-1', 'dora-deploy-w02-1', 'github:GithubRepo:1:dora-demo-001', 'sha0201', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-11-13 11:00:00', '2025-11-13 10:30:00');

-- Week 3 (Nov 18, 2025) - 1 deploy + 1 failure
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, cicd_scope_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES 
  ('dora-deploy-w03-1', 'dora-deploy-w03-1', 'github:GithubRepo:1:dora-demo-001', 'sha0301', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-11-20 09:00:00', '2025-11-20 08:30:00'),
  ('dora-deploy-w03-2', 'dora-deploy-w03-2', 'github:GithubRepo:1:dora-demo-001', 'sha0302', 'github:GithubRepo:1:dora-demo-001', 'FAILURE', 'PRODUCTION', '2025-11-21 14:00:00', '2025-11-21 13:30:00');

-- Week 4 (Nov 25, 2025) - 2 deploys
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, cicd_scope_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES 
  ('dora-deploy-w04-1', 'dora-deploy-w04-1', 'sha0401', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-11-26 10:00:00', '2025-11-26 09:30:00'),
  ('dora-deploy-w04-2', 'dora-deploy-w04-2', 'sha0402', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-11-28 15:00:00', '2025-11-28 14:30:00');

-- Week 5 (Dec 2, 2025) - 2 deploys
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES 
  ('dora-deploy-w05-1', 'dora-deploy-w05-1', 'sha0501', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-03 11:00:00', '2025-12-03 10:30:00'),
  ('dora-deploy-w05-2', 'dora-deploy-w05-2', 'sha0502', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-05 16:00:00', '2025-12-05 15:30:00');

-- Week 6 (Dec 9, 2025) - 3 deploys + 1 failure
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES 
  ('dora-deploy-w06-1', 'dora-deploy-w06-1', 'sha0601', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-09 09:00:00', '2025-12-09 08:30:00'),
  ('dora-deploy-w06-2', 'dora-deploy-w06-2', 'sha0602', 'github:GithubRepo:1:dora-demo-001', 'FAILURE', 'PRODUCTION', '2025-12-10 11:00:00', '2025-12-10 10:30:00'),
  ('dora-deploy-w06-3', 'dora-deploy-w06-3', 'sha0603', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-11 14:00:00', '2025-12-11 13:30:00'),
  ('dora-deploy-w06-4', 'dora-deploy-w06-4', 'sha0604', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-12 10:00:00', '2025-12-12 09:30:00');

-- Week 7 (Dec 16, 2025) - 3 deploys
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES 
  ('dora-deploy-w07-1', 'dora-deploy-w07-1', 'sha0701', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-16 10:00:00', '2025-12-16 09:30:00'),
  ('dora-deploy-w07-2', 'dora-deploy-w07-2', 'sha0702', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-18 11:00:00', '2025-12-18 10:30:00'),
  ('dora-deploy-w07-3', 'dora-deploy-w07-3', 'sha0703', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-19 15:00:00', '2025-12-19 14:30:00');

-- Week 8 (Dec 23, 2025) - 3 deploys
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES 
  ('dora-deploy-w08-1', 'dora-deploy-w08-1', 'sha0801', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-23 09:00:00', '2025-12-23 08:30:00'),
  ('dora-deploy-w08-2', 'dora-deploy-w08-2', 'sha0802', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-24 11:00:00', '2025-12-24 10:30:00'),
  ('dora-deploy-w08-3', 'dora-deploy-w08-3', 'sha0803', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-26 14:00:00', '2025-12-26 13:30:00');

-- Week 9 (Dec 30, 2025) - 4 deploys + 1 failure
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES 
  ('dora-deploy-w09-1', 'dora-deploy-w09-1', 'sha0901', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2025-12-30 10:00:00', '2025-12-30 09:30:00'),
  ('dora-deploy-w09-2', 'dora-deploy-w09-2', 'sha0902', 'github:GithubRepo:1:dora-demo-001', 'FAILURE', 'PRODUCTION', '2025-12-31 09:00:00', '2025-12-31 08:30:00'),
  ('dora-deploy-w09-3', 'dora-deploy-w09-3', 'sha0903', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-01 11:00:00', '2026-01-01 10:30:00'),
  ('dora-deploy-w09-4', 'dora-deploy-w09-4', 'sha0904', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-02 15:00:00', '2026-01-02 14:30:00'),
  ('dora-deploy-w09-5', 'dora-deploy-w09-5', 'sha0905', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-03 10:00:00', '2026-01-03 09:30:00');

-- Week 10 (Jan 6, 2026) - 4 deploys
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES 
  ('dora-deploy-w10-1', 'dora-deploy-w10-1', 'sha1001', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-06 09:00:00', '2026-01-06 08:30:00'),
  ('dora-deploy-w10-2', 'dora-deploy-w10-2', 'sha1002', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-07 11:00:00', '2026-01-07 10:30:00'),
  ('dora-deploy-w10-3', 'dora-deploy-w10-3', 'sha1003', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-08 14:00:00', '2026-01-08 13:30:00'),
  ('dora-deploy-w10-4', 'dora-deploy-w10-4', 'sha1004', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-09 10:00:00', '2026-01-09 09:30:00');

-- Week 11 (Jan 13, 2026) - 5 deploys
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES 
  ('dora-deploy-w11-1', 'dora-deploy-w11-1', 'sha1101', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-13 09:00:00', '2026-01-13 08:30:00'),
  ('dora-deploy-w11-2', 'dora-deploy-w11-2', 'sha1102', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-14 11:00:00', '2026-01-14 10:30:00'),
  ('dora-deploy-w11-3', 'dora-deploy-w11-3', 'sha1103', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-15 10:00:00', '2026-01-15 09:30:00'),
  ('dora-deploy-w11-4', 'dora-deploy-w11-4', 'sha1104', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-16 14:00:00', '2026-01-16 13:30:00'),
  ('dora-deploy-w11-5', 'dora-deploy-w11-5', 'sha1105', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-17 09:00:00', '2026-01-17 08:30:00');

-- Week 12 (Jan 20, 2026) - 5 deploys
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES 
  ('dora-deploy-w12-1', 'dora-deploy-w12-1', 'sha1201', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-20 09:00:00', '2026-01-20 08:30:00'),
  ('dora-deploy-w12-2', 'dora-deploy-w12-2', 'sha1202', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-21 11:00:00', '2026-01-21 10:30:00'),
  ('dora-deploy-w12-3', 'dora-deploy-w12-3', 'sha1203', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-22 10:00:00', '2026-01-22 09:30:00'),
  ('dora-deploy-w12-4', 'dora-deploy-w12-4', 'sha1204', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-23 14:00:00', '2026-01-23 13:30:00'),
  ('dora-deploy-w12-5', 'dora-deploy-w12-5', 'sha1205', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-24 09:00:00', '2026-01-24 08:30:00');

-- Week 13 (Jan 27, 2026) - 6 deploys (elite frequency)
INSERT INTO cicd_deployment_commits (id, cicd_deployment_id, commit_sha, repo_id, result, environment, finished_date, created_date)
VALUES 
  ('dora-deploy-w13-1', 'dora-deploy-w13-1', 'sha1301', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-27 09:00:00', '2026-01-27 08:30:00'),
  ('dora-deploy-w13-2', 'dora-deploy-w13-2', 'sha1302', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-28 11:00:00', '2026-01-28 10:30:00'),
  ('dora-deploy-w13-3', 'dora-deploy-w13-3', 'sha1303', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-29 10:00:00', '2026-01-29 09:30:00'),
  ('dora-deploy-w13-4', 'dora-deploy-w13-4', 'sha1304', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-30 14:00:00', '2026-01-30 13:30:00'),
  ('dora-deploy-w13-5', 'dora-deploy-w13-5', 'sha1305', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-01-31 09:00:00', '2026-01-31 08:30:00'),
  ('dora-deploy-w13-6', 'dora-deploy-w13-6', 'sha1306', 'github:GithubRepo:1:dora-demo-001', 'SUCCESS', 'PRODUCTION', '2026-02-01 10:00:00', '2026-02-01 09:30:00');

-- =============================================================================
-- Step 5: Create Pull Requests with Lead Time Data
-- PRs merged that were deployed - decreasing cycle time over weeks
-- =============================================================================

-- Week 1-2 PRs (long cycle time ~72 hours)
INSERT INTO pull_requests (id, base_repo_id, head_repo_id, status, title, url, author_name, created_date, merged_date)
VALUES 
  ('dora-pr-w01-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: initial setup', 'https://github.com/demo/dora-demo/pull/1', 'developer1', '2025-11-03 10:00:00', '2025-11-06 08:00:00'),
  ('dora-pr-w02-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: add user auth', 'https://github.com/demo/dora-demo/pull/2', 'developer2', '2025-11-10 09:00:00', '2025-11-13 09:00:00'),
  ('dora-pr-w02-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'fix: login bug', 'https://github.com/demo/dora-demo/pull/3', 'developer1', '2025-11-11 14:00:00', '2025-11-13 10:00:00');

-- Week 3-4 PRs (cycle time ~48 hours)
INSERT INTO pull_requests (id, base_repo_id, head_repo_id, status, title, url, author_name, created_date, merged_date)
VALUES 
  ('dora-pr-w03-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: dashboard', 'https://github.com/demo/dora-demo/pull/4', 'developer3', '2025-11-18 08:00:00', '2025-11-20 07:00:00'),
  ('dora-pr-w03-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'fix: styling', 'https://github.com/demo/dora-demo/pull/5', 'developer2', '2025-11-19 10:00:00', '2025-11-21 10:00:00'),
  ('dora-pr-w04-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: api endpoints', 'https://github.com/demo/dora-demo/pull/6', 'developer1', '2025-11-24 09:00:00', '2025-11-26 08:00:00'),
  ('dora-pr-w04-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'fix: validation', 'https://github.com/demo/dora-demo/pull/7', 'developer3', '2025-11-26 12:00:00', '2025-11-28 13:00:00');

-- Week 5-6 PRs (cycle time ~36 hours)
INSERT INTO pull_requests (id, base_repo_id, head_repo_id, status, title, url, author_name, created_date, merged_date)
VALUES 
  ('dora-pr-w05-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: notifications', 'https://github.com/demo/dora-demo/pull/8', 'developer2', '2025-12-01 14:00:00', '2025-12-03 09:00:00'),
  ('dora-pr-w05-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: email service', 'https://github.com/demo/dora-demo/pull/9', 'developer1', '2025-12-04 08:00:00', '2025-12-05 14:00:00'),
  ('dora-pr-w06-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: search', 'https://github.com/demo/dora-demo/pull/10', 'developer3', '2025-12-07 10:00:00', '2025-12-09 07:00:00'),
  ('dora-pr-w06-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'fix: search perf', 'https://github.com/demo/dora-demo/pull/11', 'developer2', '2025-12-10 08:00:00', '2025-12-11 12:00:00'),
  ('dora-pr-w06-3', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: filters', 'https://github.com/demo/dora-demo/pull/12', 'developer1', '2025-12-11 09:00:00', '2025-12-12 08:00:00');

-- Week 7-8 PRs (cycle time ~24 hours)
INSERT INTO pull_requests (id, base_repo_id, head_repo_id, status, title, url, author_name, created_date, merged_date)
VALUES 
  ('dora-pr-w07-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: reports', 'https://github.com/demo/dora-demo/pull/13', 'developer3', '2025-12-15 10:00:00', '2025-12-16 08:00:00'),
  ('dora-pr-w07-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: export csv', 'https://github.com/demo/dora-demo/pull/14', 'developer2', '2025-12-17 09:00:00', '2025-12-18 09:00:00'),
  ('dora-pr-w07-3', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'fix: export bug', 'https://github.com/demo/dora-demo/pull/15', 'developer1', '2025-12-18 14:00:00', '2025-12-19 13:00:00'),
  ('dora-pr-w08-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: scheduling', 'https://github.com/demo/dora-demo/pull/16', 'developer3', '2025-12-22 10:00:00', '2025-12-23 07:00:00'),
  ('dora-pr-w08-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: reminders', 'https://github.com/demo/dora-demo/pull/17', 'developer2', '2025-12-23 14:00:00', '2025-12-24 09:00:00'),
  ('dora-pr-w08-3', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'fix: timezone', 'https://github.com/demo/dora-demo/pull/18', 'developer1', '2025-12-25 08:00:00', '2025-12-26 12:00:00');

-- Week 9-10 PRs (cycle time ~18 hours)
INSERT INTO pull_requests (id, base_repo_id, head_repo_id, status, title, url, author_name, created_date, merged_date)
VALUES 
  ('dora-pr-w09-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: analytics', 'https://github.com/demo/dora-demo/pull/19', 'developer3', '2025-12-29 14:00:00', '2025-12-30 08:00:00'),
  ('dora-pr-w09-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: charts', 'https://github.com/demo/dora-demo/pull/20', 'developer2', '2025-12-30 15:00:00', '2025-12-31 07:00:00'),
  ('dora-pr-w09-3', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'fix: chart render', 'https://github.com/demo/dora-demo/pull/21', 'developer1', '2026-01-01 08:00:00', '2026-01-02 00:00:00'),
  ('dora-pr-w10-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: insights', 'https://github.com/demo/dora-demo/pull/22', 'developer3', '2026-01-05 14:00:00', '2026-01-06 07:00:00'),
  ('dora-pr-w10-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: trends', 'https://github.com/demo/dora-demo/pull/23', 'developer2', '2026-01-06 15:00:00', '2026-01-07 09:00:00'),
  ('dora-pr-w10-3', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'fix: trend calc', 'https://github.com/demo/dora-demo/pull/24', 'developer1', '2026-01-07 16:00:00', '2026-01-08 12:00:00'),
  ('dora-pr-w10-4', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: alerts', 'https://github.com/demo/dora-demo/pull/25', 'developer3', '2026-01-08 15:00:00', '2026-01-09 08:00:00');

-- Week 11-12 PRs (cycle time ~12 hours)
INSERT INTO pull_requests (id, base_repo_id, head_repo_id, status, title, url, author_name, created_date, merged_date)
VALUES 
  ('dora-pr-w11-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: webhooks', 'https://github.com/demo/dora-demo/pull/26', 'developer2', '2026-01-12 20:00:00', '2026-01-13 07:00:00'),
  ('dora-pr-w11-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: integrations', 'https://github.com/demo/dora-demo/pull/27', 'developer1', '2026-01-13 21:00:00', '2026-01-14 09:00:00'),
  ('dora-pr-w11-3', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'fix: webhook retry', 'https://github.com/demo/dora-demo/pull/28', 'developer3', '2026-01-14 22:00:00', '2026-01-15 08:00:00'),
  ('dora-pr-w11-4', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: slack notify', 'https://github.com/demo/dora-demo/pull/29', 'developer2', '2026-01-16 02:00:00', '2026-01-16 12:00:00'),
  ('dora-pr-w11-5', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: teams notify', 'https://github.com/demo/dora-demo/pull/30', 'developer1', '2026-01-16 21:00:00', '2026-01-17 07:00:00'),
  ('dora-pr-w12-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: sso', 'https://github.com/demo/dora-demo/pull/31', 'developer3', '2026-01-19 20:00:00', '2026-01-20 07:00:00'),
  ('dora-pr-w12-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: roles', 'https://github.com/demo/dora-demo/pull/32', 'developer2', '2026-01-20 21:00:00', '2026-01-21 09:00:00'),
  ('dora-pr-w12-3', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'fix: role perms', 'https://github.com/demo/dora-demo/pull/33', 'developer1', '2026-01-21 22:00:00', '2026-01-22 08:00:00'),
  ('dora-pr-w12-4', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: audit log', 'https://github.com/demo/dora-demo/pull/34', 'developer3', '2026-01-23 02:00:00', '2026-01-23 12:00:00'),
  ('dora-pr-w12-5', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: compliance', 'https://github.com/demo/dora-demo/pull/35', 'developer2', '2026-01-23 21:00:00', '2026-01-24 07:00:00');

-- Week 13 PRs (cycle time ~6 hours - elite)
INSERT INTO pull_requests (id, base_repo_id, head_repo_id, status, title, url, author_name, created_date, merged_date)
VALUES 
  ('dora-pr-w13-1', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: copilot assist', 'https://github.com/demo/dora-demo/pull/36', 'developer1', '2026-01-27 03:00:00', '2026-01-27 07:00:00'),
  ('dora-pr-w13-2', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: ai suggestions', 'https://github.com/demo/dora-demo/pull/37', 'developer3', '2026-01-28 05:00:00', '2026-01-28 09:00:00'),
  ('dora-pr-w13-3', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'fix: suggestion ui', 'https://github.com/demo/dora-demo/pull/38', 'developer2', '2026-01-29 04:00:00', '2026-01-29 08:00:00'),
  ('dora-pr-w13-4', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: smart review', 'https://github.com/demo/dora-demo/pull/39', 'developer1', '2026-01-30 09:00:00', '2026-01-30 12:00:00'),
  ('dora-pr-w13-5', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: auto tests', 'https://github.com/demo/dora-demo/pull/40', 'developer3', '2026-01-31 04:00:00', '2026-01-31 07:00:00'),
  ('dora-pr-w13-6', 'github:GithubRepo:1:dora-demo-001', 'github:GithubRepo:1:dora-demo-001', 'MERGED', 'feat: test coverage', 'https://github.com/demo/dora-demo/pull/41', 'developer2', '2026-02-01 05:00:00', '2026-02-01 08:00:00');

-- =============================================================================
-- Step 6: Create project_pr_metrics for Lead Time calculations
-- pr_cycle_time is in MINUTES
-- =============================================================================

INSERT INTO project_pr_metrics (id, project_name, pr_cycle_time, pr_coding_time, pr_pickup_time, pr_review_time, first_commit_sha, pr_merged_date)
VALUES
  -- Week 1-2: ~72 hours = 4320 minutes
  ('dora-pr-w01-1', 'dora-demo-project', 4200, 2400, 600, 1200, 'abc001', '2025-11-06 08:00:00'),
  ('dora-pr-w02-1', 'dora-demo-project', 4320, 2500, 700, 1120, 'abc002', '2025-11-13 09:00:00'),
  ('dora-pr-w02-2', 'dora-demo-project', 2880, 1600, 480, 800, 'abc003', '2025-11-13 10:00:00'),
  
  -- Week 3-4: ~48 hours = 2880 minutes
  ('dora-pr-w03-1', 'dora-demo-project', 2820, 1600, 500, 720, 'abc004', '2025-11-20 07:00:00'),
  ('dora-pr-w03-2', 'dora-demo-project', 2880, 1700, 480, 700, 'abc005', '2025-11-21 10:00:00'),
  ('dora-pr-w04-1', 'dora-demo-project', 2820, 1600, 500, 720, 'abc006', '2025-11-26 08:00:00'),
  ('dora-pr-w04-2', 'dora-demo-project', 2940, 1700, 540, 700, 'abc007', '2025-11-28 13:00:00'),
  
  -- Week 5-6: ~36 hours = 2160 minutes
  ('dora-pr-w05-1', 'dora-demo-project', 2280, 1300, 400, 580, 'abc008', '2025-12-03 09:00:00'),
  ('dora-pr-w05-2', 'dora-demo-project', 1800, 1000, 360, 440, 'abc009', '2025-12-05 14:00:00'),
  ('dora-pr-w06-1', 'dora-demo-project', 2100, 1200, 400, 500, 'abc010', '2025-12-09 07:00:00'),
  ('dora-pr-w06-2', 'dora-demo-project', 1680, 900, 360, 420, 'abc011', '2025-12-11 12:00:00'),
  ('dora-pr-w06-3', 'dora-demo-project', 1380, 800, 280, 300, 'abc012', '2025-12-12 08:00:00'),
  
  -- Week 7-8: ~24 hours = 1440 minutes
  ('dora-pr-w07-1', 'dora-demo-project', 1320, 720, 300, 300, 'abc013', '2025-12-16 08:00:00'),
  ('dora-pr-w07-2', 'dora-demo-project', 1440, 800, 320, 320, 'abc014', '2025-12-18 09:00:00'),
  ('dora-pr-w07-3', 'dora-demo-project', 1380, 700, 340, 340, 'abc015', '2025-12-19 13:00:00'),
  ('dora-pr-w08-1', 'dora-demo-project', 1260, 680, 280, 300, 'abc016', '2025-12-23 07:00:00'),
  ('dora-pr-w08-2', 'dora-demo-project', 1140, 600, 260, 280, 'abc017', '2025-12-24 09:00:00'),
  ('dora-pr-w08-3', 'dora-demo-project', 1680, 900, 380, 400, 'abc018', '2025-12-26 12:00:00'),
  
  -- Week 9-10: ~18 hours = 1080 minutes
  ('dora-pr-w09-1', 'dora-demo-project', 1080, 600, 240, 240, 'abc019', '2025-12-30 08:00:00'),
  ('dora-pr-w09-2', 'dora-demo-project', 960, 540, 210, 210, 'abc020', '2025-12-31 07:00:00'),
  ('dora-pr-w09-3', 'dora-demo-project', 960, 540, 210, 210, 'abc021', '2026-01-02 00:00:00'),
  ('dora-pr-w10-1', 'dora-demo-project', 1020, 560, 230, 230, 'abc022', '2026-01-06 07:00:00'),
  ('dora-pr-w10-2', 'dora-demo-project', 1080, 600, 240, 240, 'abc023', '2026-01-07 09:00:00'),
  ('dora-pr-w10-3', 'dora-demo-project', 1200, 680, 260, 260, 'abc024', '2026-01-08 12:00:00'),
  ('dora-pr-w10-4', 'dora-demo-project', 1020, 560, 230, 230, 'abc025', '2026-01-09 08:00:00'),
  
  -- Week 11-12: ~12 hours = 720 minutes
  ('dora-pr-w11-1', 'dora-demo-project', 660, 360, 150, 150, 'abc026', '2026-01-13 07:00:00'),
  ('dora-pr-w11-2', 'dora-demo-project', 720, 400, 160, 160, 'abc027', '2026-01-14 09:00:00'),
  ('dora-pr-w11-3', 'dora-demo-project', 600, 320, 140, 140, 'abc028', '2026-01-15 08:00:00'),
  ('dora-pr-w11-4', 'dora-demo-project', 600, 320, 140, 140, 'abc029', '2026-01-16 12:00:00'),
  ('dora-pr-w11-5', 'dora-demo-project', 600, 320, 140, 140, 'abc030', '2026-01-17 07:00:00'),
  ('dora-pr-w12-1', 'dora-demo-project', 660, 360, 150, 150, 'abc031', '2026-01-20 07:00:00'),
  ('dora-pr-w12-2', 'dora-demo-project', 720, 400, 160, 160, 'abc032', '2026-01-21 09:00:00'),
  ('dora-pr-w12-3', 'dora-demo-project', 600, 320, 140, 140, 'abc033', '2026-01-22 08:00:00'),
  ('dora-pr-w12-4', 'dora-demo-project', 600, 320, 140, 140, 'abc034', '2026-01-23 12:00:00'),
  ('dora-pr-w12-5', 'dora-demo-project', 600, 320, 140, 140, 'abc035', '2026-01-24 07:00:00'),
  
  -- Week 13: ~6 hours = 360 minutes (elite)
  ('dora-pr-w13-1', 'dora-demo-project', 240, 120, 60, 60, 'abc036', '2026-01-27 07:00:00'),
  ('dora-pr-w13-2', 'dora-demo-project', 240, 120, 60, 60, 'abc037', '2026-01-28 09:00:00'),
  ('dora-pr-w13-3', 'dora-demo-project', 240, 120, 60, 60, 'abc038', '2026-01-29 08:00:00'),
  ('dora-pr-w13-4', 'dora-demo-project', 180, 90, 45, 45, 'abc039', '2026-01-30 12:00:00'),
  ('dora-pr-w13-5', 'dora-demo-project', 180, 90, 45, 45, 'abc040', '2026-01-31 07:00:00'),
  ('dora-pr-w13-6', 'dora-demo-project', 180, 90, 45, 45, 'abc041', '2026-02-01 08:00:00');

-- =============================================================================
-- Step 7: Create Incidents for CFR and MTTR
-- Incidents caused by failed deployments with decreasing recovery time
-- =============================================================================

INSERT INTO incidents (id, url, title, status, created_date, resolution_date)
VALUES
  -- Week 3 incident (caused by failed deploy, 8 hour MTTR)
  ('dora-incident-w03', 'https://github.com/demo/dora-demo/issues/100', 'Production down: auth service', 'RESOLVED', '2025-11-21 14:30:00', '2025-11-21 22:30:00'),
  
  -- Week 6 incident (caused by failed deploy, 6 hour MTTR)
  ('dora-incident-w06', 'https://github.com/demo/dora-demo/issues/101', 'Search feature broken', 'RESOLVED', '2025-12-10 11:30:00', '2025-12-10 17:30:00'),
  
  -- Week 9 incident (caused by failed deploy, 4 hour MTTR)
  ('dora-incident-w09', 'https://github.com/demo/dora-demo/issues/102', 'Chart rendering errors', 'RESOLVED', '2025-12-31 09:30:00', '2025-12-31 13:30:00');

-- =============================================================================
-- Step 8: Create project_mapping to link everything to the project
-- CRITICAL: This is what the DORA dashboard uses for filtering
-- =============================================================================

-- Map the project to cicd_scopes (for deployment tracking)
INSERT INTO project_mapping (project_name, `table`, row_id, created_at, updated_at)
SELECT 'dora-demo-project', 'cicd_scopes', 'github:GithubRepo:1:dora-demo-001', NOW(), NOW()
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- Map all deployments to the project
INSERT INTO project_mapping (project_name, `table`, row_id, created_at, updated_at)
SELECT 'dora-demo-project', 'cicd_deployment_commits', cicd_deployment_id, NOW(), NOW()
FROM cicd_deployment_commits
WHERE id LIKE 'dora-%'
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- Map repos to the project
INSERT INTO project_mapping (project_name, `table`, row_id, created_at, updated_at)
VALUES ('dora-demo-project', 'repos', 'github:GithubRepo:1:dora-demo-001', NOW(), NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- Map boards to the project (for issues/incidents)
INSERT INTO project_mapping (project_name, `table`, row_id, created_at, updated_at)
VALUES ('dora-demo-project', 'boards', 'github:GithubRepo:1:dora-demo-001', NOW(), NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- =============================================================================
-- Step 9: Verify the seed data
-- =============================================================================

SELECT 'DORA Seed Data Summary' as title;

SELECT 
  'Deployments' as metric,
  COUNT(*) as total,
  SUM(CASE WHEN result = 'SUCCESS' THEN 1 ELSE 0 END) as success,
  SUM(CASE WHEN result = 'FAILURE' THEN 1 ELSE 0 END) as failed
FROM cicd_deployment_commits WHERE id LIKE 'dora-%';

SELECT 
  'Pull Requests' as metric,
  COUNT(*) as total
FROM pull_requests WHERE id LIKE 'dora-%';

SELECT 
  'PR Metrics' as metric,
  COUNT(*) as total,
  ROUND(AVG(pr_cycle_time)/60, 1) as avg_cycle_time_hours
FROM project_pr_metrics WHERE id LIKE 'dora-%';

SELECT 
  'Incidents' as metric,
  COUNT(*) as total,
  ROUND(AVG(TIMESTAMPDIFF(HOUR, created_date, resolution_date)), 1) as avg_mttr_hours
FROM incidents WHERE id LIKE 'dora-%';

SELECT 
  'Project Mappings' as metric,
  COUNT(*) as total
FROM project_mapping WHERE project_name = 'dora-demo-project';
