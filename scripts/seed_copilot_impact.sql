-- ==============================================================================
-- Copilot Impact Dashboard Seed Data
-- ==============================================================================
-- Purpose: Create correlated data between Copilot adoption and DORA metrics
-- Scope: eldrick-test-org (Connection ID 1)
-- Date Range: 2025-11-04 to 2026-02-02 (90 days, 13 weeks)
-- Story: Low adoption → Medium adoption → High adoption with improving metrics
-- ==============================================================================

-- 1. CLEAN EXISTING DATA FOR ELDRICK-TEST-ORG
DELETE FROM _tool_copilot_org_metrics WHERE scope_id = 'eldrick-test-org' AND connection_id = 1;
DELETE FROM _tool_copilot_language_metrics WHERE scope_id = 'eldrick-test-org' AND connection_id = 1;
DELETE FROM project_pr_metrics WHERE project_name = 'eldrick-test-org-demo';

-- 2. COPILOT ADOPTION DATA (90 days)
-- Phase 1 (Weeks 1-4): Low adoption ~15-25%, high cycle time
-- Phase 2 (Weeks 5-8): Growing adoption ~35-55%, improving cycle time  
-- Phase 3 (Weeks 9-13): High adoption ~65-90%, fast cycle time

INSERT INTO _tool_copilot_org_metrics (connection_id, scope_id, date, total_active_users, total_engaged_users, completion_suggestions, completion_acceptances, completion_lines_suggested, completion_lines_accepted, ide_chats, ide_chat_copy_events, ide_chat_insertion_events, dotcom_chats, seat_active_count, seat_total, created_at, updated_at) VALUES
-- Week 1 (Nov 4-10): Low adoption ~18%
(1, 'eldrick-test-org', '2025-11-04', 16, 14, 320, 86, 2400, 640, 12, 4, 6, 3, 16, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-05', 18, 15, 360, 97, 2700, 725, 14, 5, 7, 4, 18, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-06', 17, 14, 340, 92, 2550, 680, 13, 5, 6, 3, 17, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-07', 19, 16, 380, 103, 2850, 760, 15, 6, 8, 4, 19, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-08', 15, 12, 300, 81, 2250, 600, 11, 4, 5, 2, 15, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-09', 12, 10, 240, 65, 1800, 480, 8, 3, 4, 2, 12, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-10', 14, 11, 280, 76, 2100, 560, 10, 4, 5, 2, 14, 100, NOW(), NOW()),
-- Week 2 (Nov 11-17): Low adoption ~20%
(1, 'eldrick-test-org', '2025-11-11', 19, 16, 380, 106, 2850, 796, 15, 6, 8, 4, 19, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-12', 21, 18, 420, 118, 3150, 884, 17, 7, 9, 5, 21, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-13', 20, 17, 400, 112, 3000, 840, 16, 6, 8, 4, 20, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-14', 22, 19, 440, 123, 3300, 924, 18, 7, 10, 5, 22, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-15', 18, 15, 360, 101, 2700, 756, 14, 5, 7, 4, 18, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-16', 15, 12, 300, 84, 2250, 630, 10, 4, 5, 3, 15, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-17', 17, 14, 340, 95, 2550, 714, 12, 5, 6, 3, 17, 100, NOW(), NOW()),
-- Week 3 (Nov 18-24): Low-Medium adoption ~23%
(1, 'eldrick-test-org', '2025-11-18', 22, 19, 440, 128, 3300, 958, 18, 7, 10, 5, 22, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-19', 24, 21, 480, 139, 3600, 1044, 20, 8, 11, 6, 24, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-20', 23, 20, 460, 134, 3450, 1001, 19, 8, 10, 5, 23, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-21', 25, 22, 500, 145, 3750, 1087, 21, 9, 12, 6, 25, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-22', 21, 18, 420, 122, 3150, 914, 16, 6, 9, 4, 21, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-23', 17, 14, 340, 99, 2550, 740, 12, 5, 6, 3, 17, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-24', 19, 16, 380, 110, 2850, 827, 14, 6, 8, 4, 19, 100, NOW(), NOW()),
-- Week 4 (Nov 25-Dec 1): Medium adoption ~30%
(1, 'eldrick-test-org', '2025-11-25', 28, 25, 560, 170, 4200, 1275, 24, 10, 14, 7, 28, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-26', 31, 28, 620, 188, 4650, 1411, 27, 11, 16, 8, 31, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-27', 30, 27, 600, 182, 4500, 1365, 26, 11, 15, 7, 30, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-28', 32, 29, 640, 194, 4800, 1456, 28, 12, 16, 8, 32, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-29', 26, 23, 520, 158, 3900, 1183, 22, 9, 12, 6, 26, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-11-30', 22, 19, 440, 134, 3300, 1001, 18, 7, 10, 5, 22, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-01', 24, 21, 480, 146, 3600, 1092, 20, 8, 11, 5, 24, 100, NOW(), NOW()),
-- Week 5 (Dec 2-8): Medium adoption ~38%
(1, 'eldrick-test-org', '2025-12-02', 36, 33, 720, 230, 5400, 1728, 33, 14, 20, 10, 36, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-03', 39, 36, 780, 250, 5850, 1872, 36, 15, 22, 11, 39, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-04', 38, 35, 760, 243, 5700, 1824, 35, 15, 21, 10, 38, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-05', 40, 37, 800, 256, 6000, 1920, 37, 16, 23, 11, 40, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-06', 34, 31, 680, 218, 5100, 1632, 30, 13, 18, 9, 34, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-07', 30, 27, 600, 192, 4500, 1440, 26, 11, 15, 7, 30, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-08', 32, 29, 640, 205, 4800, 1536, 28, 12, 17, 8, 32, 100, NOW(), NOW()),
-- Week 6 (Dec 9-15): Medium-High adoption ~45%
(1, 'eldrick-test-org', '2025-12-09', 43, 40, 860, 284, 6450, 2128, 41, 18, 26, 13, 43, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-10', 46, 43, 920, 304, 6900, 2277, 44, 19, 28, 14, 46, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-11', 45, 42, 900, 297, 6750, 2227, 43, 19, 27, 13, 45, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-12', 47, 44, 940, 310, 7050, 2326, 45, 20, 29, 14, 47, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-13', 41, 38, 820, 271, 6150, 2029, 38, 16, 24, 12, 41, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-14', 37, 34, 740, 244, 5550, 1831, 34, 14, 21, 10, 37, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-15', 39, 36, 780, 257, 5850, 1930, 36, 15, 22, 11, 39, 100, NOW(), NOW()),
-- Week 7 (Dec 16-22): High adoption ~52%
(1, 'eldrick-test-org', '2025-12-16', 50, 47, 1000, 340, 7500, 2550, 49, 22, 32, 16, 50, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-17', 53, 50, 1060, 360, 7950, 2703, 52, 24, 34, 17, 53, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-18', 52, 49, 1040, 354, 7800, 2652, 51, 23, 33, 16, 52, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-19', 54, 51, 1080, 367, 8100, 2754, 53, 24, 35, 17, 54, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-20', 48, 45, 960, 326, 7200, 2448, 46, 20, 30, 15, 48, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-21', 44, 41, 880, 299, 6600, 2244, 42, 18, 27, 13, 44, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-22', 46, 43, 920, 313, 6900, 2346, 44, 19, 28, 14, 46, 100, NOW(), NOW()),
-- Week 8 (Dec 23-29): High adoption ~58%
(1, 'eldrick-test-org', '2025-12-23', 56, 53, 1120, 392, 8400, 2940, 56, 25, 37, 18, 56, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-24', 59, 56, 1180, 413, 8850, 3097, 59, 27, 39, 19, 59, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-25', 55, 52, 1100, 385, 8250, 2887, 54, 24, 36, 18, 55, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-26', 60, 57, 1200, 420, 9000, 3150, 60, 27, 40, 20, 60, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-27', 54, 51, 1080, 378, 8100, 2835, 53, 24, 35, 17, 54, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-28', 50, 47, 1000, 350, 7500, 2625, 49, 22, 32, 16, 50, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-29', 52, 49, 1040, 364, 7800, 2730, 51, 23, 33, 16, 52, 100, NOW(), NOW()),
-- Week 9 (Dec 30-Jan 5): High adoption ~65%
(1, 'eldrick-test-org', '2025-12-30', 63, 60, 1260, 454, 9450, 3402, 64, 29, 43, 21, 63, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2025-12-31', 66, 63, 1320, 475, 9900, 3564, 67, 31, 45, 22, 66, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-01', 62, 59, 1240, 446, 9300, 3348, 62, 28, 42, 21, 62, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-02', 67, 64, 1340, 482, 10050, 3618, 68, 31, 46, 23, 67, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-03', 61, 58, 1220, 439, 9150, 3294, 61, 28, 41, 20, 61, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-04', 57, 54, 1140, 410, 8550, 3078, 57, 26, 38, 19, 57, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-05', 59, 56, 1180, 425, 8850, 3186, 59, 27, 39, 19, 59, 100, NOW(), NOW()),
-- Week 10 (Jan 6-12): Very High adoption ~72%
(1, 'eldrick-test-org', '2026-01-06', 70, 67, 1400, 518, 10500, 3885, 72, 33, 49, 24, 70, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-07', 73, 70, 1460, 540, 10950, 4051, 75, 35, 51, 25, 73, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-08', 72, 69, 1440, 533, 10800, 3996, 74, 34, 50, 25, 72, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-09', 74, 71, 1480, 548, 11100, 4107, 76, 35, 52, 26, 74, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-10', 68, 65, 1360, 503, 10200, 3774, 69, 32, 47, 23, 68, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-11', 64, 61, 1280, 474, 9600, 3552, 65, 30, 44, 22, 64, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-12', 66, 63, 1320, 488, 9900, 3663, 67, 31, 45, 22, 66, 100, NOW(), NOW()),
-- Week 11 (Jan 13-19): Very High adoption ~78%
(1, 'eldrick-test-org', '2026-01-13', 76, 73, 1520, 578, 11400, 4332, 79, 37, 54, 27, 76, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-14', 79, 76, 1580, 600, 11850, 4503, 82, 38, 57, 28, 79, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-15', 78, 75, 1560, 593, 11700, 4446, 81, 38, 56, 28, 78, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-16', 80, 77, 1600, 608, 12000, 4560, 83, 39, 58, 29, 80, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-17', 74, 71, 1480, 562, 11100, 4218, 76, 35, 53, 26, 74, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-18', 70, 67, 1400, 532, 10500, 3990, 72, 33, 49, 25, 70, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-19', 72, 69, 1440, 547, 10800, 4104, 74, 34, 51, 25, 72, 100, NOW(), NOW()),
-- Week 12 (Jan 20-26): Elite adoption ~85%
(1, 'eldrick-test-org', '2026-01-20', 83, 80, 1660, 647, 12450, 4855, 87, 41, 61, 30, 83, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-21', 86, 83, 1720, 671, 12900, 5031, 90, 42, 64, 32, 86, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-22', 85, 82, 1700, 663, 12750, 4972, 89, 42, 63, 31, 85, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-23', 87, 84, 1740, 679, 13050, 5089, 91, 43, 65, 32, 87, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-24', 81, 78, 1620, 632, 12150, 4738, 84, 39, 59, 29, 81, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-25', 77, 74, 1540, 601, 11550, 4504, 80, 37, 55, 28, 77, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-26', 79, 76, 1580, 616, 11850, 4621, 82, 38, 57, 28, 79, 100, NOW(), NOW()),
-- Week 13 (Jan 27-Feb 2): Elite adoption ~90%
(1, 'eldrick-test-org', '2026-01-27', 88, 85, 1760, 704, 13200, 5280, 93, 44, 67, 33, 88, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-28', 91, 88, 1820, 728, 13650, 5460, 96, 46, 70, 35, 91, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-29', 90, 87, 1800, 720, 13500, 5400, 95, 45, 69, 34, 90, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-30', 92, 89, 1840, 736, 13800, 5520, 97, 47, 71, 35, 92, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-01-31', 86, 83, 1720, 688, 12900, 5160, 90, 42, 65, 32, 86, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-02-01', 82, 79, 1640, 656, 12300, 4920, 86, 40, 61, 30, 82, 100, NOW(), NOW()),
(1, 'eldrick-test-org', '2026-02-02', 84, 81, 1680, 672, 12600, 5040, 88, 41, 63, 31, 84, 100, NOW(), NOW());

-- 3. PROJECT PR METRICS (Correlated with adoption - cycle time decreases as adoption increases)
-- Week 1-4: High cycle time (~48-36 hours) - Low adoption period
-- Week 5-8: Improving cycle time (~30-20 hours) - Medium adoption period  
-- Week 9-13: Fast cycle time (~16-8 hours) - High adoption period

INSERT INTO project_pr_metrics (id, project_name, first_commit_sha, pr_cycle_time, pr_coding_time, pr_pickup_time, pr_review_time, pr_created_date, pr_merged_date, deployment_commit_id, created_at, updated_at) VALUES
-- Week 1: ~48 hour cycle time
('eto-pr-w1-1', 'eldrick-test-org-demo', 'sha-w1-1', 2880, 1152, 720, 1008, '2025-11-04 09:00:00', '2025-11-06 09:00:00', NULL, NOW(), NOW()),
('eto-pr-w1-2', 'eldrick-test-org-demo', 'sha-w1-2', 2760, 1104, 690, 966, '2025-11-05 10:00:00', '2025-11-07 08:00:00', NULL, NOW(), NOW()),
('eto-pr-w1-3', 'eldrick-test-org-demo', 'sha-w1-3', 2940, 1176, 735, 1029, '2025-11-06 11:00:00', '2025-11-08 12:00:00', NULL, NOW(), NOW()),
('eto-pr-w1-4', 'eldrick-test-org-demo', 'sha-w1-4', 2820, 1128, 705, 987, '2025-11-07 08:00:00', '2025-11-09 07:00:00', NULL, NOW(), NOW()),
-- Week 2: ~45 hour cycle time
('eto-pr-w2-1', 'eldrick-test-org-demo', 'sha-w2-1', 2700, 1080, 675, 945, '2025-11-11 09:00:00', '2025-11-13 06:00:00', NULL, NOW(), NOW()),
('eto-pr-w2-2', 'eldrick-test-org-demo', 'sha-w2-2', 2640, 1056, 660, 924, '2025-11-12 10:00:00', '2025-11-14 06:00:00', NULL, NOW(), NOW()),
('eto-pr-w2-3', 'eldrick-test-org-demo', 'sha-w2-3', 2760, 1104, 690, 966, '2025-11-13 08:00:00', '2025-11-15 06:00:00', NULL, NOW(), NOW()),
('eto-pr-w2-4', 'eldrick-test-org-demo', 'sha-w2-4', 2580, 1032, 645, 903, '2025-11-14 11:00:00', '2025-11-16 06:00:00', NULL, NOW(), NOW()),
-- Week 3: ~42 hour cycle time
('eto-pr-w3-1', 'eldrick-test-org-demo', 'sha-w3-1', 2520, 1008, 630, 882, '2025-11-18 09:00:00', '2025-11-20 03:00:00', NULL, NOW(), NOW()),
('eto-pr-w3-2', 'eldrick-test-org-demo', 'sha-w3-2', 2460, 984, 615, 861, '2025-11-19 10:00:00', '2025-11-21 03:00:00', NULL, NOW(), NOW()),
('eto-pr-w3-3', 'eldrick-test-org-demo', 'sha-w3-3', 2580, 1032, 645, 903, '2025-11-20 08:00:00', '2025-11-22 03:00:00', NULL, NOW(), NOW()),
('eto-pr-w3-4', 'eldrick-test-org-demo', 'sha-w3-4', 2400, 960, 600, 840, '2025-11-21 11:00:00', '2025-11-23 03:00:00', NULL, NOW(), NOW()),
-- Week 4: ~36 hour cycle time
('eto-pr-w4-1', 'eldrick-test-org-demo', 'sha-w4-1', 2160, 864, 540, 756, '2025-11-25 09:00:00', '2025-11-26 21:00:00', NULL, NOW(), NOW()),
('eto-pr-w4-2', 'eldrick-test-org-demo', 'sha-w4-2', 2100, 840, 525, 735, '2025-11-26 10:00:00', '2025-11-27 21:00:00', NULL, NOW(), NOW()),
('eto-pr-w4-3', 'eldrick-test-org-demo', 'sha-w4-3', 2220, 888, 555, 777, '2025-11-27 08:00:00', '2025-11-28 20:00:00', NULL, NOW(), NOW()),
('eto-pr-w4-4', 'eldrick-test-org-demo', 'sha-w4-4', 2040, 816, 510, 714, '2025-11-28 11:00:00', '2025-11-29 21:00:00', NULL, NOW(), NOW()),
-- Week 5: ~30 hour cycle time
('eto-pr-w5-1', 'eldrick-test-org-demo', 'sha-w5-1', 1800, 720, 450, 630, '2025-12-02 09:00:00', '2025-12-03 15:00:00', NULL, NOW(), NOW()),
('eto-pr-w5-2', 'eldrick-test-org-demo', 'sha-w5-2', 1740, 696, 435, 609, '2025-12-03 10:00:00', '2025-12-04 15:00:00', NULL, NOW(), NOW()),
('eto-pr-w5-3', 'eldrick-test-org-demo', 'sha-w5-3', 1860, 744, 465, 651, '2025-12-04 08:00:00', '2025-12-05 15:00:00', NULL, NOW(), NOW()),
('eto-pr-w5-4', 'eldrick-test-org-demo', 'sha-w5-4', 1680, 672, 420, 588, '2025-12-05 11:00:00', '2025-12-06 15:00:00', NULL, NOW(), NOW()),
('eto-pr-w5-5', 'eldrick-test-org-demo', 'sha-w5-5', 1920, 768, 480, 672, '2025-12-06 09:00:00', '2025-12-07 17:00:00', NULL, NOW(), NOW()),
-- Week 6: ~26 hour cycle time
('eto-pr-w6-1', 'eldrick-test-org-demo', 'sha-w6-1', 1560, 624, 390, 546, '2025-12-09 09:00:00', '2025-12-10 11:00:00', NULL, NOW(), NOW()),
('eto-pr-w6-2', 'eldrick-test-org-demo', 'sha-w6-2', 1500, 600, 375, 525, '2025-12-10 10:00:00', '2025-12-11 11:00:00', NULL, NOW(), NOW()),
('eto-pr-w6-3', 'eldrick-test-org-demo', 'sha-w6-3', 1620, 648, 405, 567, '2025-12-11 08:00:00', '2025-12-12 11:00:00', NULL, NOW(), NOW()),
('eto-pr-w6-4', 'eldrick-test-org-demo', 'sha-w6-4', 1440, 576, 360, 504, '2025-12-12 11:00:00', '2025-12-13 11:00:00', NULL, NOW(), NOW()),
('eto-pr-w6-5', 'eldrick-test-org-demo', 'sha-w6-5', 1680, 672, 420, 588, '2025-12-13 09:00:00', '2025-12-14 13:00:00', NULL, NOW(), NOW()),
-- Week 7: ~22 hour cycle time
('eto-pr-w7-1', 'eldrick-test-org-demo', 'sha-w7-1', 1320, 528, 330, 462, '2025-12-16 09:00:00', '2025-12-17 07:00:00', NULL, NOW(), NOW()),
('eto-pr-w7-2', 'eldrick-test-org-demo', 'sha-w7-2', 1260, 504, 315, 441, '2025-12-17 10:00:00', '2025-12-18 07:00:00', NULL, NOW(), NOW()),
('eto-pr-w7-3', 'eldrick-test-org-demo', 'sha-w7-3', 1380, 552, 345, 483, '2025-12-18 08:00:00', '2025-12-19 07:00:00', NULL, NOW(), NOW()),
('eto-pr-w7-4', 'eldrick-test-org-demo', 'sha-w7-4', 1200, 480, 300, 420, '2025-12-19 11:00:00', '2025-12-20 07:00:00', NULL, NOW(), NOW()),
('eto-pr-w7-5', 'eldrick-test-org-demo', 'sha-w7-5', 1440, 576, 360, 504, '2025-12-20 09:00:00', '2025-12-21 09:00:00', NULL, NOW(), NOW()),
-- Week 8: ~18 hour cycle time
('eto-pr-w8-1', 'eldrick-test-org-demo', 'sha-w8-1', 1080, 432, 270, 378, '2025-12-23 09:00:00', '2025-12-24 03:00:00', NULL, NOW(), NOW()),
('eto-pr-w8-2', 'eldrick-test-org-demo', 'sha-w8-2', 1020, 408, 255, 357, '2025-12-24 10:00:00', '2025-12-25 03:00:00', NULL, NOW(), NOW()),
('eto-pr-w8-3', 'eldrick-test-org-demo', 'sha-w8-3', 1140, 456, 285, 399, '2025-12-26 08:00:00', '2025-12-27 03:00:00', NULL, NOW(), NOW()),
('eto-pr-w8-4', 'eldrick-test-org-demo', 'sha-w8-4', 960, 384, 240, 336, '2025-12-27 11:00:00', '2025-12-28 03:00:00', NULL, NOW(), NOW()),
('eto-pr-w8-5', 'eldrick-test-org-demo', 'sha-w8-5', 1200, 480, 300, 420, '2025-12-28 09:00:00', '2025-12-29 05:00:00', NULL, NOW(), NOW()),
-- Week 9: ~14 hour cycle time
('eto-pr-w9-1', 'eldrick-test-org-demo', 'sha-w9-1', 840, 336, 210, 294, '2025-12-30 09:00:00', '2025-12-30 23:00:00', NULL, NOW(), NOW()),
('eto-pr-w9-2', 'eldrick-test-org-demo', 'sha-w9-2', 780, 312, 195, 273, '2025-12-31 10:00:00', '2025-12-31 23:00:00', NULL, NOW(), NOW()),
('eto-pr-w9-3', 'eldrick-test-org-demo', 'sha-w9-3', 900, 360, 225, 315, '2026-01-02 08:00:00', '2026-01-02 23:00:00', NULL, NOW(), NOW()),
('eto-pr-w9-4', 'eldrick-test-org-demo', 'sha-w9-4', 720, 288, 180, 252, '2026-01-03 11:00:00', '2026-01-03 23:00:00', NULL, NOW(), NOW()),
('eto-pr-w9-5', 'eldrick-test-org-demo', 'sha-w9-5', 960, 384, 240, 336, '2026-01-04 09:00:00', '2026-01-05 01:00:00', NULL, NOW(), NOW()),
('eto-pr-w9-6', 'eldrick-test-org-demo', 'sha-w9-6', 660, 264, 165, 231, '2026-01-05 10:00:00', '2026-01-05 21:00:00', NULL, NOW(), NOW()),
-- Week 10: ~12 hour cycle time
('eto-pr-w10-1', 'eldrick-test-org-demo', 'sha-w10-1', 720, 288, 180, 252, '2026-01-06 09:00:00', '2026-01-06 21:00:00', NULL, NOW(), NOW()),
('eto-pr-w10-2', 'eldrick-test-org-demo', 'sha-w10-2', 660, 264, 165, 231, '2026-01-07 10:00:00', '2026-01-07 21:00:00', NULL, NOW(), NOW()),
('eto-pr-w10-3', 'eldrick-test-org-demo', 'sha-w10-3', 780, 312, 195, 273, '2026-01-08 08:00:00', '2026-01-08 21:00:00', NULL, NOW(), NOW()),
('eto-pr-w10-4', 'eldrick-test-org-demo', 'sha-w10-4', 600, 240, 150, 210, '2026-01-09 11:00:00', '2026-01-09 21:00:00', NULL, NOW(), NOW()),
('eto-pr-w10-5', 'eldrick-test-org-demo', 'sha-w10-5', 840, 336, 210, 294, '2026-01-10 09:00:00', '2026-01-10 23:00:00', NULL, NOW(), NOW()),
('eto-pr-w10-6', 'eldrick-test-org-demo', 'sha-w10-6', 540, 216, 135, 189, '2026-01-11 10:00:00', '2026-01-11 19:00:00', NULL, NOW(), NOW()),
-- Week 11: ~10 hour cycle time
('eto-pr-w11-1', 'eldrick-test-org-demo', 'sha-w11-1', 600, 240, 150, 210, '2026-01-13 09:00:00', '2026-01-13 19:00:00', NULL, NOW(), NOW()),
('eto-pr-w11-2', 'eldrick-test-org-demo', 'sha-w11-2', 540, 216, 135, 189, '2026-01-14 10:00:00', '2026-01-14 19:00:00', NULL, NOW(), NOW()),
('eto-pr-w11-3', 'eldrick-test-org-demo', 'sha-w11-3', 660, 264, 165, 231, '2026-01-15 08:00:00', '2026-01-15 19:00:00', NULL, NOW(), NOW()),
('eto-pr-w11-4', 'eldrick-test-org-demo', 'sha-w11-4', 480, 192, 120, 168, '2026-01-16 11:00:00', '2026-01-16 19:00:00', NULL, NOW(), NOW()),
('eto-pr-w11-5', 'eldrick-test-org-demo', 'sha-w11-5', 720, 288, 180, 252, '2026-01-17 09:00:00', '2026-01-17 21:00:00', NULL, NOW(), NOW()),
('eto-pr-w11-6', 'eldrick-test-org-demo', 'sha-w11-6', 420, 168, 105, 147, '2026-01-18 10:00:00', '2026-01-18 17:00:00', NULL, NOW(), NOW()),
('eto-pr-w11-7', 'eldrick-test-org-demo', 'sha-w11-7', 780, 312, 195, 273, '2026-01-19 08:00:00', '2026-01-19 21:00:00', NULL, NOW(), NOW()),
-- Week 12: ~8 hour cycle time
('eto-pr-w12-1', 'eldrick-test-org-demo', 'sha-w12-1', 480, 192, 120, 168, '2026-01-20 09:00:00', '2026-01-20 17:00:00', NULL, NOW(), NOW()),
('eto-pr-w12-2', 'eldrick-test-org-demo', 'sha-w12-2', 420, 168, 105, 147, '2026-01-21 10:00:00', '2026-01-21 17:00:00', NULL, NOW(), NOW()),
('eto-pr-w12-3', 'eldrick-test-org-demo', 'sha-w12-3', 540, 216, 135, 189, '2026-01-22 08:00:00', '2026-01-22 17:00:00', NULL, NOW(), NOW()),
('eto-pr-w12-4', 'eldrick-test-org-demo', 'sha-w12-4', 360, 144, 90, 126, '2026-01-23 11:00:00', '2026-01-23 17:00:00', NULL, NOW(), NOW()),
('eto-pr-w12-5', 'eldrick-test-org-demo', 'sha-w12-5', 600, 240, 150, 210, '2026-01-24 09:00:00', '2026-01-24 19:00:00', NULL, NOW(), NOW()),
('eto-pr-w12-6', 'eldrick-test-org-demo', 'sha-w12-6', 300, 120, 75, 105, '2026-01-25 10:00:00', '2026-01-25 15:00:00', NULL, NOW(), NOW()),
('eto-pr-w12-7', 'eldrick-test-org-demo', 'sha-w12-7', 660, 264, 165, 231, '2026-01-26 08:00:00', '2026-01-26 19:00:00', NULL, NOW(), NOW()),
-- Week 13: ~6 hour cycle time
('eto-pr-w13-1', 'eldrick-test-org-demo', 'sha-w13-1', 360, 144, 90, 126, '2026-01-27 09:00:00', '2026-01-27 15:00:00', NULL, NOW(), NOW()),
('eto-pr-w13-2', 'eldrick-test-org-demo', 'sha-w13-2', 300, 120, 75, 105, '2026-01-28 10:00:00', '2026-01-28 15:00:00', NULL, NOW(), NOW()),
('eto-pr-w13-3', 'eldrick-test-org-demo', 'sha-w13-3', 420, 168, 105, 147, '2026-01-29 08:00:00', '2026-01-29 15:00:00', NULL, NOW(), NOW()),
('eto-pr-w13-4', 'eldrick-test-org-demo', 'sha-w13-4', 240, 96, 60, 84, '2026-01-30 11:00:00', '2026-01-30 15:00:00', NULL, NOW(), NOW()),
('eto-pr-w13-5', 'eldrick-test-org-demo', 'sha-w13-5', 480, 192, 120, 168, '2026-01-31 09:00:00', '2026-01-31 17:00:00', NULL, NOW(), NOW()),
('eto-pr-w13-6', 'eldrick-test-org-demo', 'sha-w13-6', 180, 72, 45, 63, '2026-02-01 10:00:00', '2026-02-01 13:00:00', NULL, NOW(), NOW()),
('eto-pr-w13-7', 'eldrick-test-org-demo', 'sha-w13-7', 540, 216, 135, 189, '2026-02-02 08:00:00', '2026-02-02 17:00:00', NULL, NOW(), NOW());

-- 4. DEPLOYMENTS (for DORA metrics - increasing frequency with adoption)
DELETE FROM cicd_deployment_commits WHERE id LIKE 'eto-deploy-%';

INSERT INTO cicd_deployment_commits (id, cicd_scope_id, cicd_deployment_id, name, result, status, environment, created_date, started_date, finished_date, duration_sec, commit_sha, created_at, updated_at) VALUES
-- Week 1-4: 1-2 deploys per week, some failures (CFR ~25%)
('eto-deploy-w1-1', 'eldrick-test-org-demo', 'eto-deploy-w1-1', 'Deploy v1.0.0', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-11-06 14:00:00', '2025-11-06 14:00:00', '2025-11-06 14:15:00', 900, 'sha-w1-1', NOW(), NOW()),
('eto-deploy-w2-1', 'eldrick-test-org-demo', 'eto-deploy-w2-1', 'Deploy v1.0.1', 'FAILURE', 'DONE', 'PRODUCTION', '2025-11-13 14:00:00', '2025-11-13 14:00:00', '2025-11-13 14:10:00', 600, 'sha-w2-2', NOW(), NOW()),
('eto-deploy-w2-2', 'eldrick-test-org-demo', 'eto-deploy-w2-2', 'Deploy v1.0.2', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-11-14 10:00:00', '2025-11-14 10:00:00', '2025-11-14 10:12:00', 720, 'sha-w2-3', NOW(), NOW()),
('eto-deploy-w3-1', 'eldrick-test-org-demo', 'eto-deploy-w3-1', 'Deploy v1.1.0', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-11-20 14:00:00', '2025-11-20 14:00:00', '2025-11-20 14:12:00', 720, 'sha-w3-1', NOW(), NOW()),
('eto-deploy-w4-1', 'eldrick-test-org-demo', 'eto-deploy-w4-1', 'Deploy v1.1.1', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-11-27 14:00:00', '2025-11-27 14:00:00', '2025-11-27 14:10:00', 600, 'sha-w4-2', NOW(), NOW()),
('eto-deploy-w4-2', 'eldrick-test-org-demo', 'eto-deploy-w4-2', 'Deploy v1.1.2', 'FAILURE', 'DONE', 'PRODUCTION', '2025-11-29 16:00:00', '2025-11-29 16:00:00', '2025-11-29 16:08:00', 480, 'sha-w4-4', NOW(), NOW()),
-- Week 5-8: 2-3 deploys per week, fewer failures (CFR ~10%)
('eto-deploy-w5-1', 'eldrick-test-org-demo', 'eto-deploy-w5-1', 'Deploy v1.2.0', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-12-03 14:00:00', '2025-12-03 14:00:00', '2025-12-03 14:10:00', 600, 'sha-w5-2', NOW(), NOW()),
('eto-deploy-w5-2', 'eldrick-test-org-demo', 'eto-deploy-w5-2', 'Deploy v1.2.1', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-12-05 14:00:00', '2025-12-05 14:00:00', '2025-12-05 14:08:00', 480, 'sha-w5-4', NOW(), NOW()),
('eto-deploy-w6-1', 'eldrick-test-org-demo', 'eto-deploy-w6-1', 'Deploy v1.3.0', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-12-10 14:00:00', '2025-12-10 14:00:00', '2025-12-10 14:08:00', 480, 'sha-w6-2', NOW(), NOW()),
('eto-deploy-w6-2', 'eldrick-test-org-demo', 'eto-deploy-w6-2', 'Deploy v1.3.1', 'FAILURE', 'DONE', 'PRODUCTION', '2025-12-12 14:00:00', '2025-12-12 14:00:00', '2025-12-12 14:06:00', 360, 'sha-w6-4', NOW(), NOW()),
('eto-deploy-w6-3', 'eldrick-test-org-demo', 'eto-deploy-w6-3', 'Deploy v1.3.2', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-12-13 10:00:00', '2025-12-13 10:00:00', '2025-12-13 10:06:00', 360, 'sha-w6-5', NOW(), NOW()),
('eto-deploy-w7-1', 'eldrick-test-org-demo', 'eto-deploy-w7-1', 'Deploy v1.4.0', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-12-17 14:00:00', '2025-12-17 14:00:00', '2025-12-17 14:06:00', 360, 'sha-w7-2', NOW(), NOW()),
('eto-deploy-w7-2', 'eldrick-test-org-demo', 'eto-deploy-w7-2', 'Deploy v1.4.1', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-12-19 14:00:00', '2025-12-19 14:00:00', '2025-12-19 14:05:00', 300, 'sha-w7-4', NOW(), NOW()),
('eto-deploy-w8-1', 'eldrick-test-org-demo', 'eto-deploy-w8-1', 'Deploy v1.5.0', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-12-24 14:00:00', '2025-12-24 14:00:00', '2025-12-24 14:05:00', 300, 'sha-w8-2', NOW(), NOW()),
('eto-deploy-w8-2', 'eldrick-test-org-demo', 'eto-deploy-w8-2', 'Deploy v1.5.1', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-12-27 14:00:00', '2025-12-27 14:00:00', '2025-12-27 14:04:00', 240, 'sha-w8-4', NOW(), NOW()),
-- Week 9-13: 3-4 deploys per week, minimal failures (CFR ~5%)
('eto-deploy-w9-1', 'eldrick-test-org-demo', 'eto-deploy-w9-1', 'Deploy v2.0.0', 'SUCCESS', 'DONE', 'PRODUCTION', '2025-12-31 14:00:00', '2025-12-31 14:00:00', '2025-12-31 14:04:00', 240, 'sha-w9-2', NOW(), NOW()),
('eto-deploy-w9-2', 'eldrick-test-org-demo', 'eto-deploy-w9-2', 'Deploy v2.0.1', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-03 14:00:00', '2026-01-03 14:00:00', '2026-01-03 14:03:00', 180, 'sha-w9-4', NOW(), NOW()),
('eto-deploy-w9-3', 'eldrick-test-org-demo', 'eto-deploy-w9-3', 'Deploy v2.0.2', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-05 10:00:00', '2026-01-05 10:00:00', '2026-01-05 10:03:00', 180, 'sha-w9-6', NOW(), NOW()),
('eto-deploy-w10-1', 'eldrick-test-org-demo', 'eto-deploy-w10-1', 'Deploy v2.1.0', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-07 14:00:00', '2026-01-07 14:00:00', '2026-01-07 14:03:00', 180, 'sha-w10-2', NOW(), NOW()),
('eto-deploy-w10-2', 'eldrick-test-org-demo', 'eto-deploy-w10-2', 'Deploy v2.1.1', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-09 14:00:00', '2026-01-09 14:00:00', '2026-01-09 14:02:00', 120, 'sha-w10-4', NOW(), NOW()),
('eto-deploy-w10-3', 'eldrick-test-org-demo', 'eto-deploy-w10-3', 'Deploy v2.1.2', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-11 10:00:00', '2026-01-11 10:00:00', '2026-01-11 10:02:00', 120, 'sha-w10-6', NOW(), NOW()),
('eto-deploy-w11-1', 'eldrick-test-org-demo', 'eto-deploy-w11-1', 'Deploy v2.2.0', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-14 14:00:00', '2026-01-14 14:00:00', '2026-01-14 14:02:00', 120, 'sha-w11-2', NOW(), NOW()),
('eto-deploy-w11-2', 'eldrick-test-org-demo', 'eto-deploy-w11-2', 'Deploy v2.2.1', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-16 14:00:00', '2026-01-16 14:00:00', '2026-01-16 14:02:00', 120, 'sha-w11-4', NOW(), NOW()),
('eto-deploy-w11-3', 'eldrick-test-org-demo', 'eto-deploy-w11-3', 'Deploy v2.2.2', 'FAILURE', 'DONE', 'PRODUCTION', '2026-01-18 10:00:00', '2026-01-18 10:00:00', '2026-01-18 10:01:00', 60, 'sha-w11-6', NOW(), NOW()),
('eto-deploy-w11-4', 'eldrick-test-org-demo', 'eto-deploy-w11-4', 'Deploy v2.2.3', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-18 12:00:00', '2026-01-18 12:00:00', '2026-01-18 12:01:00', 60, 'sha-w11-6', NOW(), NOW()),
('eto-deploy-w12-1', 'eldrick-test-org-demo', 'eto-deploy-w12-1', 'Deploy v2.3.0', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-21 14:00:00', '2026-01-21 14:00:00', '2026-01-21 14:01:00', 60, 'sha-w12-2', NOW(), NOW()),
('eto-deploy-w12-2', 'eldrick-test-org-demo', 'eto-deploy-w12-2', 'Deploy v2.3.1', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-23 14:00:00', '2026-01-23 14:00:00', '2026-01-23 14:01:00', 60, 'sha-w12-4', NOW(), NOW()),
('eto-deploy-w12-3', 'eldrick-test-org-demo', 'eto-deploy-w12-3', 'Deploy v2.3.2', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-25 10:00:00', '2026-01-25 10:00:00', '2026-01-25 10:01:00', 60, 'sha-w12-6', NOW(), NOW()),
('eto-deploy-w13-1', 'eldrick-test-org-demo', 'eto-deploy-w13-1', 'Deploy v2.4.0', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-28 14:00:00', '2026-01-28 14:00:00', '2026-01-28 14:01:00', 60, 'sha-w13-2', NOW(), NOW()),
('eto-deploy-w13-2', 'eldrick-test-org-demo', 'eto-deploy-w13-2', 'Deploy v2.4.1', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-01-30 14:00:00', '2026-01-30 14:00:00', '2026-01-30 14:01:00', 60, 'sha-w13-4', NOW(), NOW()),
('eto-deploy-w13-3', 'eldrick-test-org-demo', 'eto-deploy-w13-3', 'Deploy v2.4.2', 'SUCCESS', 'DONE', 'PRODUCTION', '2026-02-01 10:00:00', '2026-02-01 10:00:00', '2026-02-01 10:01:00', 60, 'sha-w13-6', NOW(), NOW());

-- 5. INCIDENTS (for MTTR - improving over time)
DELETE FROM issues WHERE id LIKE 'eto-incident-%';

INSERT INTO issues (id, url, issue_key, title, type, status, original_status, created_date, updated_date, resolution_date, lead_time_minutes, creator_id, creator_name, priority, original_project) VALUES
-- Week 2: Incident from failed deploy - 8 hour MTTR
('eto-incident-w2-1', 'https://github.com/eldrick-test-org/demo/issues/100', 'INC-1', 'Production deployment failure', 'INCIDENT', 'DONE', 'closed', '2025-11-13 14:30:00', '2025-11-13 22:30:00', '2025-11-13 22:30:00', 480, 'user1', 'Alice', 'P1', 'eldrick-test-org-demo'),
-- Week 4: Incident - 6 hour MTTR  
('eto-incident-w4-1', 'https://github.com/eldrick-test-org/demo/issues/101', 'INC-2', 'API timeout errors', 'INCIDENT', 'DONE', 'closed', '2025-11-29 16:30:00', '2025-11-29 22:30:00', '2025-11-29 22:30:00', 360, 'user2', 'Bob', 'P1', 'eldrick-test-org-demo'),
-- Week 6: Incident - 4 hour MTTR
('eto-incident-w6-1', 'https://github.com/eldrick-test-org/demo/issues/102', 'INC-3', 'Database connection issues', 'INCIDENT', 'DONE', 'closed', '2025-12-12 14:30:00', '2025-12-12 18:30:00', '2025-12-12 18:30:00', 240, 'user3', 'Charlie', 'P2', 'eldrick-test-org-demo'),
-- Week 11: Incident - 2 hour MTTR (fast recovery with high Copilot)
('eto-incident-w11-1', 'https://github.com/eldrick-test-org/demo/issues/103', 'INC-4', 'Memory spike incident', 'INCIDENT', 'DONE', 'closed', '2026-01-18 10:30:00', '2026-01-18 12:30:00', '2026-01-18 12:30:00', 120, 'user1', 'Alice', 'P2', 'eldrick-test-org-demo');

-- Summary output
SELECT 'Copilot Adoption metrics' AS data_type, COUNT(*) AS records FROM _tool_copilot_org_metrics WHERE scope_id = 'eldrick-test-org' AND connection_id = 1
UNION ALL
SELECT 'PR Metrics', COUNT(*) FROM project_pr_metrics WHERE project_name = 'eldrick-test-org-demo'
UNION ALL
SELECT 'Deployments', COUNT(*) FROM cicd_deployment_commits WHERE id LIKE 'eto-deploy-%'
UNION ALL
SELECT 'Incidents', COUNT(*) FROM issues WHERE id LIKE 'eto-incident-%';
