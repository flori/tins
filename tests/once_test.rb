require 'test_helper'

module Tins
  class OnceTest < Test::Unit::TestCase
    def fn
      @fn ||= File.join(Dir.tmpdir, "once_test.#{SecureRandom.hex(4)}")
    end

    def cleanup
      File.delete(fn) if File.exist?(fn)
    end

    def test_only_once_touch_creates_missing_lock_file
      File.delete(fn) if File.exist?(fn)
      File.delete("#{fn}.old") if File.exist?("#{fn}.old")
      assert_equal 42, Once.only_once(fn, touch: true) { 42 }
      assert File.exist?(fn)
    ensure
      cleanup
    end

    def test_only_once_without_touch_raises_enoent_when_missing
      File.delete(fn) if File.exist?(fn)
      assert_raise(Errno::ENOENT) do
        Once.only_once(fn) { 42 }
      end
    ensure
      cleanup
    end

    def test_try_only_once_touch_creates_missing_lock_file
      File.delete(fn) if File.exist?(fn)
      assert_equal :ok, Once.try_only_once(fn, touch: true) { :ok }
      assert File.exist?(fn)
    ensure
      cleanup
    end

    def test_try_only_once_without_touch_raises_enoent_when_missing
      File.delete(fn) if File.exist?(fn)
      assert_raise(Errno::ENOENT) do
        Once.try_only_once(fn) { :ok }
      end
    ensure
      cleanup
    end

    def test_only_once_releases_lock_after_block
      Once.only_once(fn, touch: true) { :first }
      # A second invocation (fresh FD) must succeed once the first is done.
      assert_equal :second, Once.only_once(fn, touch: true) { :second }
    ensure
      cleanup
    end

    def test_try_only_once_returns_false_when_lock_already_held
      # Cross-process contention: a forked child holds the flock on
      # the lock file; the parent's try_only_once must return false
      # (flock with LOCK_NB returns false, not raise EAGAIN) and the
      # block must be skipped. This is the real-world scenario (two
      # ollama_chat instances in the same directory).
      # `path` is captured *before* the fork so both parent and
      # child reference the same literal string.
      path = fn
      Once.only_once(path, touch: true) { }  # ensure file exists

      r, w = IO.pipe
      pid = fork do
        r.close
        f = File.open(path, File::RDONLY)
        f.flock(File::LOCK_EX)
        w.write('locked')
        w.close
        sleep 60  # hold the lock until killed
      end
      w.close
      r.read(6)   # wait for child to confirm lock is held
      r.close

      assert_equal false, Once.try_only_once(path) { :blocked }
    ensure
      if pid
        begin
          Process.kill('TERM', pid)
        rescue Errno::ESRCH
          # child already exited (a failed assertion took it down first)
        end
        Process.wait(pid)
      end
      cleanup
    end
  end
end
